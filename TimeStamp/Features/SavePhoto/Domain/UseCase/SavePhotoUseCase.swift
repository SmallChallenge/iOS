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

    /// 사진을 저장하고 Core Data에 로그 생성
    func savePhoto(image: UIImage, category: String, visibility: String) throws {
        // String → Entity enum 변환 (rawValue 사용)
        let categoryEnum = Category(rawValue: category) ?? .etc

        let visibilityEnum: VisibilityType = visibility == "publicVisible" ? .publicVisible : .privateVisible

        // Repository를 통해 저장
        try repository.savePhoto(
            image: image,
            category: categoryEnum,
            timeStamp: Date(),
            visibility: visibilityEnum
        )
    }
}
