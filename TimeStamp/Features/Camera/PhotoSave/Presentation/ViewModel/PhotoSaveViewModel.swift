//
//  PhotoSaveViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit
import Combine

// MARK: - Notification Names

extension Notification.Name {
    static let shouldRefresh = Notification.Name("shouldRefres")
    static let shouldRefreshMyLog = Notification.Name("shouldRefreshMyLog")
    
    /// 방금 저장됨
    static let didSaveLog = Notification.Name("savedLog")
}

/// 사진 저장 화면의 비즈니스 로직을 관리하는 ViewModel
@MainActor
final class PhotoSaveViewModel: ObservableObject, MessageDisplayable {

    // MARK: - Properties

    /// 사진 저장 UseCase
    private let useCase: PhotoSaveUseCaseProtocol
    private let selectedCategoryType: String
    private let selectedTamplateId: String

    /// 저장 성공 여부
    @Published var isSaved = false

    /// 로딩
    @Published var isLoading: Bool = false

    /// 에러 메시지
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    // MARK: - Init

    init(useCase: PhotoSaveUseCaseProtocol, selectedCategoryType: String, selectedTamplateId: String) {
        self.useCase = useCase
        self.selectedCategoryType = selectedCategoryType
        self.selectedTamplateId = selectedTamplateId
    }

    // MARK: - Actions
    
    /// 사진 저장 (로컬 or 서버)
    /// - NOTE: 로그인 상태면 서버에 저장, 로그아웃상태면 로컬에 저장
    func savePhoto(image: UIImage, category: CategoryViewData, visibility: VisibilityViewData) {
        guard isLoading == false else { return }

        // 갤러리에 사진 저장
        let isGalleySave = useCase.getIsAutoSave()
        if isGalleySave {
            useCase.savePhotoToGallery(image: image)
        }

        // 로그인 여부 확인
        if AuthManager.shared.isLoggedIn {
            // 로그인되어 있으면 서버에 저장
            Task {
                await savePhotoToServer(image: image, category: category, visibility: visibility)
                
                /// 앰플리튜드
                trackPhotoSave(category: category, visibility: visibility)
            }
        } else {
            // 로그아웃 상태면 로컬에 저장
            savePhotoToLocal(image: image, category: category, visibility: visibility)
        }
    }
    
    private func trackPhotoSave(category: CategoryViewData, visibility: VisibilityViewData) {
        let categoryEntity = CategoryMapper().toEntity(from: category)
        let visibilityEntity = VisibilityTypeMapper().toEntity(from: visibility)
        
        AmplitudeManager.shared.trackCompletePhotoSave(
            category: categoryEntity.rawValue.lowercased(),
            visibility: visibilityEntity.rawValue.lowercased(),
            templateId: selectedTamplateId,
            templateCategory: selectedCategoryType
        )
        if visibility == .publicVisible {
            AmplitudeManager.shared.trackPublicPhotoUpload(category: categoryEntity)
        }
    }
    
    // TODO: 사진 저장개수 카운트
    private func saveCount(){
        
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
            ToastManager.shared.show(AppMessage.saveSuccess.text)
            Logger.success("사진 저장 성공")
            
            // TODO: 사진 저장개수 카운트

            // MyLogView에 새로고침 알림
            NotificationCenter.default.post(name: .shouldRefreshMyLog, object: nil)
            
            // MainTabView에 저장됨을 알림.
            NotificationCenter.default.post(name: .didSaveLog, object: nil)

        } catch {
            // 저장 실패
            show(.saveFailed)
            Logger.error("로컬 사진 저장 실패: \(error)")
        }
    }
    
    // 서버에 사진 저장하기
    private func savePhotoToServer(image: UIImage, category: CategoryViewData, visibility: VisibilityViewData) async {
        do {
            let categoryEntity = CategoryMapper().toEntity(from: category)
            let visibilityEntity = VisibilityTypeMapper().toEntity(from: visibility)

            isLoading = true
            try await useCase.savePhotoToServer(image: image, category: categoryEntity, visibility: visibilityEntity)

            // 저장 성공
            isSaved = true
            isLoading = false
            ToastManager.shared.show(AppMessage.saveSuccess.text)
            Logger.success("서버에 사진 저장 성공")
            
            // TODO: 사진 저장개수 카운트

            // MyLogView에 새로고침 알림
            NotificationCenter.default.post(name: .shouldRefreshMyLog, object: nil)
            
            // MainTabView에 저장됨을 알림.
            NotificationCenter.default.post(name: .didSaveLog, object: nil)

        } catch {
            // 저장 실패
            isLoading = false
            
            if let networkError = error as? NetworkError,
               networkError == .noInternet {
                show(.noInternet)
            } else {
                show(.saveFailed)
            }
            Logger.error("서버에 사진 저장 실패: \(error)")
        }
    }
}
