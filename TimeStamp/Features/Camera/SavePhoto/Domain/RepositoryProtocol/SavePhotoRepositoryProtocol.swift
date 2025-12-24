//
//  SavePhotoRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit

/// SavePhoto Repository Protocol (Domain Layer)
/// - Entity 기반 인터페이스
/// - Data Layer에서 구현
protocol SavePhotoRepositoryProtocol {
    /// coredata에 사진을 저장하고 타임스탬프 로그 생성
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - category: 카테고리
    ///   - timeStamp: 타임스탬프
    ///   - visibility: 공개 여부
    /// - Throws: 저장 실패 시 에러
    func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType, timeStamp: String) throws
    
    
    
    func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType, timeStamp: String) throws
}
