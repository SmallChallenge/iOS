//
//  PhotoSaveUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit

struct PhotoSaveUseCase: PhotoSaveUseCaseProtocol {

    // MARK: - Properties

    private let repository: PhotoSaveRepositoryProtocol

    // MARK: - Init

    init(repository: PhotoSaveRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Methods

    /// Core Data에 사진을 저장하고
    func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType) throws {
        // 1. 타임스탬프 생성
        let dateString = Date().toString(.iso8601)

        // 2. 파일 이름 생성
        let fileName = "\(UUID().uuidString)_\(Date().timeIntervalSince1970).jpg"

        // 3. DTO 생성
        let dto = LocalTimeStampLogDto(
            id: UUID(),
            category: category.rawValue,
            timeStamp: dateString,
            imageFileName: fileName,
            visibility: visibility.rawValue
        )

        // 4. Repository에 전달하여 저장
        try repository.savePhotoToLocal(
            image: image,
            fileName: fileName,
            dto: dto
        )
    }
    
    func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType) async throws {
        // 1. 타임스탬프 생성
        let dateString = Date().toString(format: "yyyy-MM-dd'T'HH:mm:ss")

        // 2. 이미지를 JPEG 데이터로 변환
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw FileManagerError.imageConversionFailed
        }

        // 3. 파일 크기 가져오기
        let fileSize = imageData.count

        // 4. 고유한 파일명 생성
        let fileName = "\(UUID().uuidString)_\(Date().toString(.dateOnly)).jpg"

        // 5. presignedUrl 받기
        let (presignedUrl, objectKey) = try await repository.getPresignedUrl(
            fileName: fileName,
            imageSize: fileSize
        )

        // 6. S3에 이미지 업로드
        try await repository.uploadImageToS3(
            imageData: imageData,
            presignedUrl: presignedUrl
        )

        // 7. 서버에 메타데이터 저장
        try await repository.saveTimeStampMetadata(
            fileName: fileName,
            imageSize: fileSize,
            objectKey: objectKey,
            category: category.rawValue,
            visibility: visibility.rawValue,
            timeStamp: dateString
        )
    }

    func savePhotoToGallery(image: UIImage) {
        repository.savePhotoToGallery(image: image)
    }
}
