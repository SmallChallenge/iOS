//
//  LogEditorViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//


import Foundation
import Combine


final class LogEditorViewModel: ObservableObject, MessageDisplayable {
    private let authManager = AuthManager.shared
    private let useCase: LogEditorUseCaseProtocol
    private let categoryMapper = CategoryMapper()
    @Published var log: TimeStampLogViewData

    // MARK: - Output Properties
    @Published var isLoading = false

    @Published var selectedCategory: CategoryViewData
    @Published var selectedVisibility: VisibilityViewData
    @Published var hasEdited: Bool = false

    @Published var toastMessage: String?
    @Published var alertMessage: String?

    init(log: TimeStampLogViewData, useCase: LogEditorUseCaseProtocol) {
        self.log = log
        self.useCase = useCase
        self.selectedCategory = log.category
        self.selectedVisibility = log.visibility
    }
    
    
    /// 전체공개버튼 노출 여부
    /// - note: 서버데이터 일 때만 노출
    func isPublicVisibility() ->  Bool {
        if case .remote = log.imageSource {
            return true
        }
        return false
    }

    
    func editLog() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                // ViewData를 Entity로 변환
                let categoryEntity = categoryMapper.toEntity(from: selectedCategory)
                let visibilityEntity = VisibilityTypeMapper().toEntity(from: selectedVisibility)
                
                switch log.imageSource {
                case let .remote(remoteImage):
                    // 서버 로그 수정
                    let result = try await useCase.editLogForServer(
                        logId: remoteImage.id,
                        category: categoryEntity,
                        visibility: visibilityEntity
                    )
                    Logger.success("서버 로그 수정 성공: \(result)")
                    
                    // 앰플리튜드
                    // 비공개 -> 전체공개가 된 경우..
                    if log.visibility == .privateVisible &&
                        selectedVisibility == .publicVisible {
                        AmplitudeManager.shared.trackPublicPhotoUpload(category: categoryEntity)
                    }
                    
                    
                case .local:
                    // 로컬 로그 수정
                    try useCase.editLogForLocal(
                        logId: log.id,
                        category: categoryEntity,
                        visibility: visibilityEntity
                    )
                    Logger.success("로컬 로그 수정 성공")
                }
                hasEdited = true
            } catch {
                Logger.error("로그 수정 실패: \(error)")
                show(.editFailed)
            }
            isLoading = false
        }
    }
}

