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
    private var authManager = AuthManager.shared

    // MARK: - Properties

    /// 사진 저장 UseCase
    private let useCase: PhotoSaveUseCaseProtocol
    
    /// 앰플리튜드용 템플릿id, style 값
    private let selectedTemplateStyle: String
    private let selectedTamplateId: String
    
    // 선택된 카테고리
    @Published var selectedCategory: CategoryViewData? = nil
    @Published var selectedVisibility: VisibilityViewData? = nil
    
    
    // 로컬 기록 한계 도달 팝업 띄우기
    @Published var showLimitReachedPopup = false

    /// 저장 성공 여부
    @Published var isSaved = false

    /// 로딩
    @Published var isLoading: Bool = false

    /// 에러 메시지
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    // MARK: - Init

    init(useCase: PhotoSaveUseCaseProtocol, selectedTemplateStyle: String, selectedTamplateId: String) {
        self.useCase = useCase
        self.selectedTemplateStyle = selectedTemplateStyle
        self.selectedTamplateId = selectedTamplateId
    }

    // MARK: - Actions
    
    
    
    /// 사진 저장 (로컬 or 서버)
    /// - NOTE: 로그인 상태면 서버에 저장, 로그아웃상태면 로컬에 저장
    func savePhoto(image: UIImage) {
        
        // 카테고리, 공개 여부가 선택되었는지 확인
        guard let category = selectedCategory,
              let visibility = selectedVisibility
        else {
            show(.requiredSelection)
            return
        }
        
        // 앱 실행시, 카메라 바로가기 기능 때문에, 여기서 로컬저장 개수 제한 확인하고 팝업띄우기 (비공개로 저장할 경우)
        guard canTakePhoto() || visibility == .publicVisible else {
            showLimitReachedPopup = true
            return
        }
        
        
        guard isLoading == false else { return }

        // 갤러리에 사진 저장
        let isGalleySave = useCase.getIsAutoSave()
        if isGalleySave {
            useCase.savePhotoToGallery(image: image)
        }

        // 로그인 여부 확인
        if authManager.isLoggedIn {
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
        // 앰플리튜드 - 사진 저장 완료 (로컬, 서버 구분 없이)
        AmplitudeManager.shared.trackComplatePhotoSaveCount()
    }
    
    private func trackPhotoSave(category: CategoryViewData, visibility: VisibilityViewData) {
        let categoryEntity = CategoryMapper().toEntity(from: category)
        let visibilityEntity = VisibilityTypeMapper().toEntity(from: visibility)
        
        // 사진 저장 완료 (서버에만)
        AmplitudeManager.shared.trackCompletePhotoSave(
            category: categoryEntity.rawValue.lowercased(),
            visibility: visibilityEntity.rawValue.lowercased(),
            templateId: selectedTamplateId,
            templateCategory: selectedTemplateStyle
        )
        if visibility == .publicVisible {
            // 전체공개로 사진 업로드 or 전체공개로 사진을 수정한 경우
            AmplitudeManager.shared.trackPublicPhotoUpload(category: categoryEntity)
        }
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
    
    @MainActor
    /// 이전에 선택했던 카테고리 가져오기
    func getLastSelectedCategory() {
        guard let category = useCase.getLastSelectedCategory() else { return }
        Task {
            let categoryViewData = CategoryViewDataMapper().toViewData(from: category)
            self.selectedCategory = categoryViewData
        }
    }
    
    @MainActor
    /// 이전에 선택했던 공개여부 가져오기
    func getLastSelectedVisibilityType() {
        guard let visibilityType = useCase.getLastSelectedVisibilityType() else { return }
        Task {
            let visibilityTypeViewData = VisibilityViewDataMapper().toViewData(from: visibilityType)
            
            // 공개인데 비로그인 상태면 선택 X
            guard (authManager.isLoggedIn) || (visibilityTypeViewData == .privateVisible) else { return }
            self.selectedVisibility = visibilityTypeViewData
        }
    }
    
    
    /// 카메라 촬영 가능 여부 확인 (로컬 기록이 20개 미만인지)
    ///  비로그인 상태로, 로컬기록이 20개 이상이면 -> false
    /// - Returns: 촬영 가능하면 true, 제한에 도달하면 false
    private func canTakePhoto() -> Bool {
        return authManager.isLoggedIn || getLocalLogsCount() < AppConstants.Limits.maxLogCount
    }
    
    /// 로컬 기록 개수 확인
    /// - Returns: 로컬에 저장된 기록 개수
    private func getLocalLogsCount() -> Int {
        return useCase.getLocalLogsCount()
    }
}

