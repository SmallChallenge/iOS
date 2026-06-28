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

    /// 전체 사진 목록
    private var allPhotos: [PHAsset] = []

    /// 현재 표시 중인 사진 목록
    @Published var photos: [PHAsset]? = nil

    /// 선택된 이미지
    @Published var selectedImage: UIImage? = nil

    /// 선택된 이미지의 촬영 날짜
    @Published var selectedImageDate: Date? = nil

    /// 권한 알림 표시 여부
    @Published var showPermissionAlert = false

    /// 로딩 상태
    @Published var isLoading = false

    /// 추가 로딩 상태
    @Published var isLoadingMore = false

    /// 페이지네이션 설정
    private let pageSize = 30
    private var currentIndex = 0

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

    /// 사진 목록 로드 (초기 로드)
    func loadPhotos() {
        allPhotos = useCase.fetchPhotos()
        currentIndex = 0
        photos = []
        loadMore()
    }

    /// 추가 사진 로드 (페이지네이션)
    func loadMore() {
        guard !isLoadingMore else { return }
        guard currentIndex < allPhotos.count else { return }

        isLoadingMore = true

        let endIndex = min(currentIndex + pageSize, allPhotos.count)
        let newPhotos = Array(allPhotos[currentIndex..<endIndex])

        if photos == nil {
            photos = newPhotos
        } else {
            photos?.append(contentsOf: newPhotos)
        }

        currentIndex = endIndex
        isLoadingMore = false
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
