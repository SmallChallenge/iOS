//
//  SavePhotoRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit

/// SavePhoto Repository 구현 (Data Layer)
/// - LocalTimeStampLogRepository를 사용하여 로컬 데이터 저장
/// - 이미지 파일 저장 기능 포함
final class SavePhotoRepository: SavePhotoRepositoryProtocol {

    // MARK: - Properties

    /// 로컬 저장소 (CoreData)
    private let localRepository: LocalTimeStampLogRepositoryProtocol

    // TODO: 나중에 추가
    // private let remoteRepository: RemoteTimeStampLogRepositoryProtocol

    // MARK: - Init

    init(localRepository: LocalTimeStampLogRepositoryProtocol) {
        self.localRepository = localRepository
    }

    // MARK: - SavePhotoRepositoryProtocol

    /// 사진을 저장하고 타임스탬프 로그 생성
    func savePhoto(image: UIImage, category: Category, timeStamp: Date, visibility: VisibilityType) throws {
        // 1. 이미지를 파일로 저장
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
        try localRepository.create(dto)

        // TODO: 나중에 서버에도 업로드
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
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw SavePhotoError.imageConversionFailed
        }

        // 파일로 저장
        try imageData.write(to: fileURL)

        return fileName
    }
}
