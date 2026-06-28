//
//  PhotoSaveUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit

protocol PhotoSaveUseCaseProtocol {
    /// 사진을 저장하고 Core Data에 로그 생성
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - category: 카테고리
    ///   - visibility: 공개 여부
    /// - Throws: 저장 실패 시 에러
    func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType) throws

    func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType) async throws

    /// 갤러리에 사진 저장
    /// - Parameter image: 저장할 이미지
    func savePhotoToGallery(image: UIImage)
    
    
    func getIsAutoSave() -> Bool
    
    /// 이전에 선택했던 카테고리 가져오기
    func getLastSelectedCategory() -> Category?
    
    /// 이전에 선택했던 공개여부 가져오기
    func getLastSelectedVisibilityType() -> VisibilityType?
    
    
    /// 로컬 타임스탬프 로그의 개수를 조회
    /// - Returns: 로컬에 저장된 로그의 개수
    func getLocalLogsCount() -> Int
}
