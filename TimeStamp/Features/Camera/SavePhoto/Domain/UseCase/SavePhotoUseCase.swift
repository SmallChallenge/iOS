//
//  SavePhotoUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit

struct SavePhotoUseCase: SavePhotoUseCaseProtocol {

    // MARK: - Properties

    private let repository: SavePhotoRepositoryProtocol

    // MARK: - Init

    init(repository: SavePhotoRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Methods

    /// Core Data에 사진을 저장하고
    func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType) throws {
        
        // "2024-01-15T10:30:00"
        let dateString = Date().toString(.iso8601)

        // Repository를 통해 저장
        try repository.savePhotoToLacal(
            image: image,
            category: category.rawValue,
            visibility: visibility.rawValue,
            timeStamp: dateString
        )
    }
    
    func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType) async throws {
        // 1. 타임스탬프 생성
        let dateString = Date().toString(format: "yyyy-MM-dd'T'HH:mm:ss")

        // 2. 이미지를 JPEG 데이터로 변환
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw SavePhotoError.imageConversionFailed
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
}
