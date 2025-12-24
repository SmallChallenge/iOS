//
//  SavePhotoRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit

/// SavePhoto Repository 구현 (Data Layer)
/// - LocalTimeStampLogDataSource를 사용하여 로컬 데이터 저장
/// - 이미지 파일 저장 기능 포함
final class SavePhotoRepository: SavePhotoRepositoryProtocol {
   

    // MARK: - Properties

    /// 이미지 압축율
    private let imageCompressionQuality: CGFloat = 0.8

    /// 로컬 저장소 (CoreData)
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    // TODO: 나중에 추가
    // private let remoteDataSource: RemoteTimeStampLogDataSourceProtocol

    // MARK: - Init

    init(localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    // MARK: - SavePhoto

    /// 사진 저장하고, CoreData에 타임스탬프 저장
    func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType, timeStamp: String) throws {
        // 1. 이미지를 파일로 저장 (이미지를 Documents 디렉토리에 저장)
        let fileName = try saveImageToDocuments(image: image)

        // 2. Entity를 DTO로 변환
        let dto = LocalTimeStampLogDto(
            id: UUID(),
            category: category.rawValue,
            timeStamp: timeStamp,
            imageFileName: fileName,
            visibility: visibility == .publicVisible ? "publicVisible" : "privateVisible"
        )

        // 3. 로컬 저장소에 저장
        try localDataSource.create(dto)
    }
    
    /// 서버에 사진 저장
    func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType, timeStamp: String) throws {
        
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
}
