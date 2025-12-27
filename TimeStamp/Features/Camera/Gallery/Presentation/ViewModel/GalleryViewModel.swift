//
//  GalleryViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation
import Photos
import UIKit
import Combine

@MainActor
final class GalleryViewModel: ObservableObject {

    // MARK: - Properties

    let useCase: GalleryUseCaseProtocol

    /// 사진 목록
    @Published var photos: [PHAsset] = []

    /// 선택된 이미지
    @Published var selectedImage: UIImage? = nil

    /// 선택된 이미지의 촬영 날짜
    @Published var selectedImageDate: Date? = nil

    /// 권한 알림 표시 여부
    @Published var showPermissionAlert = false

    /// 로딩 상태
    @Published var isLoading = false

    // MARK: - Init

    init(useCase: GalleryUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Actions

    /// 사진 라이브러리 권한 확인 및 요청
    func checkAndRequestPermission() async {
        let status = await useCase.checkAndRequestPermission()

        switch status {
        case .authorized, .limited:
            loadPhotos()
        case .denied, .restricted, .notDetermined:
            showPermissionAlert = true
        @unknown default:
            showPermissionAlert = true
        }
    }

    /// 사진 목록 로드
    func loadPhotos() {
        photos = useCase.fetchPhotos()
    }

    /// 전체 크기 이미지 로드
    func loadFullImage(from asset: PHAsset) async {
        isLoading = true
        selectedImage = await useCase.loadFullImage(from: asset)
        selectedImageDate = asset.creationDate
        isLoading = false
    }

    /// 선택된 이미지 초기화
    func clearSelectedImage() {
        selectedImage = nil
        selectedImageDate = nil
    }
}
