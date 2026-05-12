//
//  PhotoSaveRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit

/// PhotoSave Repository Protocol (Domain Layer)
/// - Entity 기반 인터페이스
/// - Data Layer에서 구현
protocol PhotoSaveRepositoryProtocol {

    /// 이미지를 파일로 저장하고 DTO를 DataSource에 저장
    func savePhotoToLocal(image: UIImage, fileName: String, dto: LocalTimeStampLogDto) throws

    // MARK: - Server API

    /// presignedUrl 받기
    func getPresignedUrl(fileName: String, imageSize: Int) async throws -> (presignedUrl: String, objectKey: String)

    /// S3에 이미지 업로드
    func uploadImageToS3(imageData: Data, presignedUrl: String) async throws

    /// 서버에 타임스탬프 메타데이터 저장
    func saveTimeStampMetadata(fileName: String, imageSize: Int, objectKey: String, category: String, visibility: String, timeStamp: String) async throws

    // MARK: - Gallery

    /// 갤러리에 사진 저장
    /// - Parameter image: 저장할 이미지
    func savePhotoToGallery(image: UIImage)
    
    // MARK: - app config
    
    func getIsAutoSave() -> Bool
    
    func saveLogCount()
    
    /// 이전에 선택했던 카테고리 가져오기
    func getLastSelectedCategory() -> Category?
    
    /// 선택한 카테고리 저장
    func saveSelectedCategory(category: Category)
    
    /// 이전에 선택했던 공개여부 가져오기
    func getLastSelectedVisibilityType() -> VisibilityType?
    
    /// 선택한 공개여부 저장
    func saveSelectedVisibilityType(visibilityType: VisibilityType)
}
