//
//  SavePhotoRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit
import Alamofire

/// SavePhoto Repository 구현 (Data Layer)
/// - LocalTimeStampLogDataSource를 사용하여 로컬 데이터 저장
/// - 이미지 파일 저장 기능 포함
final class SavePhotoRepository: SavePhotoRepositoryProtocol {
   
    // MARK: - Properties

    /// 이미지 압축율
    private let imageCompressionQuality: CGFloat = 0.8

    /// 로컬 저장소 (CoreData)
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    /// 서버 API 클라이언트
    private let apiClient: SavePhotoApiClientProtocol

    // MARK: - Init

    init(localDataSource: LocalTimeStampLogDataSourceProtocol,
         apiClient: SavePhotoApiClientProtocol) {
        self.localDataSource = localDataSource
        self.apiClient = apiClient
    }

    // MARK: - SavePhoto

    /// 사진 저장하고, CoreData에 타임스탬프 저장
    func savePhotoToLacal(image: UIImage, category: String, visibility: String, timeStamp: String) throws {
        // 1. 이미지를 파일로 저장 (이미지를 Documents 디렉토리에 저장)
        let fileName = try saveImageToDocuments(image: image)

        // 2. Entity를 DTO로 변환
        let dto = LocalTimeStampLogDto(
            id: UUID(),
            category: category,
            timeStamp: timeStamp,
            imageFileName: fileName,
            visibility: visibility
        )

        // 3. 로컬 저장소에 저장
        try localDataSource.create(dto)
    }
    
    // MARK: - Server API

    /// presignedUrl 받기
    func getPresignedUrl(fileName: String, imageSize: Int) async throws -> (presignedUrl: String, objectKey: String) {
        let result = await apiClient.presignedUrl(fileName: fileName, size: imageSize)

        guard case .success(let response) = result else {
            if case .failure(let error) = result {
                Logger.error("presignedUrl 요청 실패: \(error)")
            }
            throw SavePhotoError.networkError
        }

        guard let uploadURL = response.data?.uploadURL,
              let objectKey = response.data?.objectKey else {
            Logger.error("data is nil")
            throw SavePhotoError.networkError
        }
        
        Logger.success("presignedUrl 받기 성공")
        return (uploadURL, objectKey)
    }

    /// S3에 이미지 업로드 (helper를 재사용)
    func uploadImageToS3(imageData: Data, presignedUrl: String) async throws {
        try await uploadImageToS3Helper(imageData: imageData, presignedUrl: presignedUrl)
    }

    /// 서버에 타임스탬프 메타데이터 저장
    func saveTimeStampMetadata(fileName: String, imageSize: Int, objectKey: String, category: String, visibility: String, timeStamp: String) async throws {
        let result = await apiClient.saveTimeStamp(
            fileName: fileName,
            size: imageSize,
            objectKey: objectKey,
            category: category,
            visibility: visibility,
            originalTakenAt: timeStamp
        )

        guard case .success(let response) = result else {
            if case .failure(let error) = result {
                Logger.error("saveTimeStamp 요청 실패: \(error)")
            }
            throw SavePhotoError.networkError
        }
        guard let imageId = response.data?.imageId else {
            Logger.error("data is nil")
            throw SavePhotoError.networkError
        }
        Logger.success("서버에 메타데이터 저장 성공: imageId=\(imageId)")
    }
    

    

    // MARK: - Private Helpers

    /// 이미지를 Documents 디렉토리에 저장
    private func saveImageToDocuments(image: UIImage) throws -> String {
        // 고유한 파일명 생성 (UUID + timestamp)
        let fileName = "\(UUID().uuidString)_\(Date().timeIntervalSince1970).jpg"

        // Documents 디렉토리 경로 가져오기
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw SavePhotoError.documentsDirectoryNotFound
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        // 이미지를 JPEG 데이터로 변환 (압축률 0.8)
        guard let imageData = image.jpegData(compressionQuality: imageCompressionQuality) else {
            throw SavePhotoError.imageConversionFailed
        }

        // 파일로 저장
        try imageData.write(to: fileURL)

        return fileName
    }

    /// S3에 이미지 업로드 (Private Helper)
    private func uploadImageToS3Helper(imageData: Data, presignedUrl: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(imageData, to: presignedUrl, method: .put, headers: ["Content-Type": "image/jpeg"])
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        Logger.success("S3에 이미지 업로드 성공")
                        continuation.resume()
                    case .failure(let error):
                        Logger.error("S3 이미지 업로드 실패: \(error)")
                        continuation.resume(throwing: SavePhotoError.networkError)
                    }
                }
        }
    }
}
