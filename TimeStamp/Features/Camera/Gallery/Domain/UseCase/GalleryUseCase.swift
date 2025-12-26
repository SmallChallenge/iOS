//
//  GalleryUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation
import Photos
import UIKit

final class GalleryUseCase: GalleryUseCaseProtocol {
    private let repository: PhotoLibraryRepositoryProtocol

    init(repository: PhotoLibraryRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Permission

    func checkAndRequestPermission() async -> PHAuthorizationStatus {
        let currentStatus = repository.checkAuthorizationStatus()

        switch currentStatus {
        case .authorized, .limited:
            return currentStatus
        case .notDetermined:
            return await repository.requestAuthorization()
        case .denied, .restricted:
            return currentStatus
        @unknown default:
            return currentStatus
        }
    }

    // MARK: - Fetch Photos

    func fetchPhotos() -> [PHAsset] {
        return repository.fetchPhotos()
    }

    // MARK: - Load Images

    func loadThumbnail(from asset: PHAsset) async -> UIImage? {
        let thumbnailSize = CGSize(width: 300, height: 300)
        return await repository.loadImage(from: asset, targetSize: thumbnailSize)
    }

    func loadFullImage(from asset: PHAsset) async -> UIImage? {
        // 원본 크기로 로드 (나중에 editor에서 크롭 예정)
        let fullSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
        return await repository.loadImage(from: asset, targetSize: fullSize)
    }
}
