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
            category: category,
            visibility: visibility,
            timeStamp: dateString
        )
    }
    
    func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType) throws {
        
        // "2024-01-15T10:30:00"
        let dateString = Date().toString(format: "yyyy-MM-dd'T'HH:mm:ss")
        
    }
}
