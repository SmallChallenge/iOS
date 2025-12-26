//
//  GalleryUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation
import Photos
import UIKit

protocol GalleryUseCaseProtocol {
    /// 사진 라이브러리 권한 확인 및 요청
    func checkAndRequestPermission() async -> PHAuthorizationStatus

    /// 사진 목록 가져오기
    func fetchPhotos() -> [PHAsset]

    /// 썸네일 이미지 로드
    func loadThumbnail(from asset: PHAsset) async -> UIImage?

    /// 전체 크기 이미지 로드
    func loadFullImage(from asset: PHAsset) async -> UIImage?
}
