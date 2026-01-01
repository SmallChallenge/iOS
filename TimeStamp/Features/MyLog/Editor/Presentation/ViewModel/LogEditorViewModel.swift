//
//  LogEditorViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//


import Foundation
import Combine


final class LogEditorViewModel: ObservableObject {
    private let authManager = AuthManager.shared
    @Published var log: TimeStampLogViewData
    
    // MARK: - Output Properties
    @Published var isLoading = false
    
    @Published var selectedCategory: CategoryViewData
    @Published var selectedVisibility: VisibilityViewData
    
    
    @Published var toastMessage: String?
    @Published var alertMessage: String?
    
    init(log: TimeStampLogViewData) {
        self.log = log
        self.selectedCategory = log.category
        self.selectedVisibility = log.visibility
    }
    
    
    /// 전체공개버튼 노출 여부
    /// - note: 로그인 상태여야 하고 로그가 서버데이터 여야함. 로컬데에터는 전체공개 전환 안됨.
    func isPublicVisibility() ->  Bool {
        switch log.imageSource {
        case .remote:
            return authManager.isLoggedIn
        default: return false
        }
    }

}

