//
//  SavePhotoViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit
import Combine

// MARK: - Notification Names

extension Notification.Name {
    static let didSavePhoto = Notification.Name("didSavePhoto")
}

/// 사진 저장 화면의 비즈니스 로직을 관리하는 ViewModel
@MainActor
final class SavePhotoViewModel: ObservableObject {

    // MARK: - Properties

    /// 사진 저장 UseCase
    private let useCase: SavePhotoUseCaseProtocol

    /// 저장 성공 여부
    @Published var isSaved = false
    
    /// 로딩
    @Published var isLoading: Bool = false

    /// 에러 메시지
    @Published var errorMessage: String?

    // MARK: - Init

    init(useCase: SavePhotoUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Actions
    
    func savePhoto(image: UIImage, category: CategoryViewData, visibility: VisibilityViewData){
        // TODO: 로그인 여부 확인, 로그인되어있으면 -> 서버 저장, 로그아웃 -> 로컬 저장
    }
    

    /// 사진을 파일로 저장하고 Core Data에 로그 저장
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - category: 선택된 카테고리
    ///   - visibility: 공개 여부
    private func savePhotoToLocal(image: UIImage, category: CategoryViewData, visibility: VisibilityViewData) {
        do {
            let categoryEntity = CategoryMapper().toEntity(from: category)
            let visibilityEntity = VisibilityTypeMapper().toEntity(from: visibility)
            try useCase.savePhotoToLacal(image: image, category: categoryEntity, visibility: visibilityEntity)

            // 저장 성공
            isSaved = true
            Logger.success("사진 저장 성공")

            // MyLogView에 새로고침 알림
            NotificationCenter.default.post(name: .didSavePhoto, object: nil)

        } catch {
            // 저장 실패
            errorMessage = "사진 저장에 실패했습니다: \(error.localizedDescription)"
            Logger.error("사진 저장 실패: \(error)")
        }
    }
    
    private func savePhotoToServer(image: UIImage, category: CategoryViewData, visibility: VisibilityViewData){
        
        
    }
    
}
