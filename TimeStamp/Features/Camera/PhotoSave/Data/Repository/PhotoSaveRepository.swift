//
//  PhotoSaveRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit
import Alamofire
import Photos

/// PhotoSave Repository 구현 (Data Layer)
/// - LocalTimeStampLogDataSource를 사용하여 로컬 데이터 저장
/// - 이미지 파일 저장 기능 포함
final class PhotoSaveRepository: PhotoSaveRepositoryProtocol {

    // MARK: - Properties

    /// 이미지 압축율
    private let imageCompressionQuality: CGFloat = 0.8

    /// 로컬 저장소 (CoreData)
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    /// 서버 API 클라이언트
    private let apiClient: PhotoSaveApiClientProtocol

    // MARK: - Init

    init(localDataSource: LocalTimeStampLogDataSourceProtocol,
         apiClient: PhotoSaveApiClientProtocol) {
        self.localDataSource = localDataSource
        self.apiClient = apiClient
    }

    // MARK: - SavePhoto

    /// 이미지를 파일로 저장하고 DTO를 DataSource에 저장
    func savePhotoToLocal(image: UIImage, fileName: String, dto: LocalTimeStampLogDto) throws {
        // 1. 주어진 fileName으로 이미지 저장
        try saveImageToDocuments(fileName: fileName, image: image)

        // 2. DTO를 로컬 저장소에 저장
        try localDataSource.create(dto)
    }
    
    // MARK: - Server API

    /// presignedUrl 받기
    func getPresignedUrl(fileName: String, imageSize: Int) async throws -> (presignedUrl: String, objectKey: String) {
        let result = await apiClient.presignedUrl(fileName: fileName, size: imageSize)

        switch result {
        case .success(let dto):
            Logger.success("presignedUrl 받기 성공")
            return (dto.uploadURL, dto.objectKey)

        case .failure(let error):
            Logger.error("presignedUrl 요청 실패: \(error)")
            throw error
        }
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

        switch result {
        case .success(let dto):
            Logger.success("서버에 메타데이터 저장 성공: imageId=\(dto.imageId)")

        case .failure(let error):
            Logger.error("saveTimeStamp 요청 실패: \(error)")
            throw error
        }
    }

    // MARK: - Gallery

    /// 갤러리에 사진 저장
    func savePhotoToGallery(image: UIImage) {
        // Stampy 앨범 찾기 또는 생성
        let albumName = AppConstants.AppInfo.appNameKr

        // 앨범이 존재하는지 확인
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", albumName)
        let collection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)

        if let album = collection.firstObject {
            // 앨범이 이미 존재하면 해당 앨범에 사진 추가
            saveImageToAlbum(image: image, album: album)
        } else {
            // 앨범이 없으면 생성 후 사진 추가
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: albumName)
            }) { success, error in
                if success {
                    // 앨범 생성 성공 후 다시 앨범을 찾아서 사진 추가
                    let newCollection = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
                    if let newAlbum = newCollection.firstObject {
                        self.saveImageToAlbum(image: image, album: newAlbum)
                    }
                } else if let error = error {
                    Logger.error("\(albumName) 앨범 생성 실패: \(error)")
                }
            }
        }
    }

    // MARK: - Private Helpers

    /// 이미지를 Documents 디렉토리에 저장
    private func saveImageToDocuments(fileName: String, image: UIImage) throws {
        // Documents 디렉토리 경로 가져오기
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw FileManagerError.documentsDirectoryNotFound
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        // 이미지를 JPEG 데이터로 변환 (압축률 0.8)
        guard let imageData = image.jpegData(compressionQuality: imageCompressionQuality) else {
            throw FileManagerError.imageConversionFailed
        }

        // 파일로 저장
        try imageData.write(to: fileURL)
    }

    /// S3에 이미지 업로드 (Private Helper)
    private func uploadImageToS3Helper(imageData: Data, presignedUrl: String) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(imageData, to: presignedUrl, method: .put, headers: ["Content-Type": "image/jpeg", "x-amz-acl": "public-read"])
                .validate()
                .response { response in
                    switch response.result {
                    case .success:
                        Logger.success("S3에 이미지 업로드 성공")
                        continuation.resume()
                    case .failure(let error):
                        Logger.error("S3 이미지 업로드 실패: \(error)")
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    /// 특정 앨범에 이미지 저장 (Private Helper)
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - album: 저장할 앨범
    private func saveImageToAlbum(image: UIImage, album: PHAssetCollection) {
        PHPhotoLibrary.shared().performChanges({
            let assetRequest = PHAssetChangeRequest.creationRequestForAsset(from: image)
            guard let placeholder = assetRequest.placeholderForCreatedAsset,
                  let albumChangeRequest = PHAssetCollectionChangeRequest(for: album) else {
                return
            }
            albumChangeRequest.addAssets([placeholder] as NSArray)
        }) { success, error in
            if success {
                Logger.success("Stampic 앨범에 사진 저장 성공")
            } else if let error = error {
                Logger.error("Stampic 앨범에 사진 저장 실패: \(error)")
            }
        }
    }
}
