//
//  PhotoLibraryRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation
import Photos
import UIKit

/// PhotoLibrary Repository Protocol (Domain Layer)
protocol PhotoLibraryRepositoryProtocol {
    /// 사진 라이브러리 권한 상태 확인
    func checkAuthorizationStatus() -> PHAuthorizationStatus

    /// 사진 라이브러리 권한 요청
    func requestAuthorization() async -> PHAuthorizationStatus

    /// 사진 목록 가져오기
    func fetchPhotos() -> [PHAsset]

    /// PHAsset으로부터 이미지 로드
    func loadImage(from asset: PHAsset, targetSize: CGSize) async -> UIImage?
}
