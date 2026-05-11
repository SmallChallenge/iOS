//
//  MainTabViewModel.swift
//  TimeStamp
//
//  Created by Claude on 12/31/24.
//

import Foundation
import Combine
import GoogleMobileAds

@MainActor
final class MainTabViewModel: ObservableObject {

    // MARK: - Properties
    private var authManager = AuthManager.shared
    private let useCase: MainTabUseCaseProtocol
    
    

    // MARK: - Init

    init(useCase: MainTabUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // MARK: - Output Properties
    
    /// 리뷰팝업 띄울지 여부
    @Published var showReviewPopup: Bool = false
    
    @Published var toastMessage: String?
    

    // MARK: - Methods

    /// 로컬 기록 개수 확인
    /// - Returns: 로컬에 저장된 기록 개수
    func getLocalLogsCount() -> Int {
        return useCase.getLocalLogsCount()
    }

    /// 카메라 촬영 가능 여부 확인 (로컬 기록이 20개 미만인지)
    ///  비로그인 상태로, 로컬기록이 20개 이상이면 -> false
    /// - Returns: 촬영 가능하면 true, 제한에 도달하면 false
    func canTakePhoto() -> Bool {
        return authManager.isLoggedIn || getLocalLogsCount() < AppConstants.Limits.maxLogCount
    }
    
    /// 추적허용 권한 받기
    func requestAuthorization() async {
        guard !TrackingManager.shared.isTrackingAuthorized else {
            // 이미 추적허용받음
            return }
        
        // 추적 권한 요청
        let _ = await TrackingManager.shared.requestTrackingAuthorization()

        // 추적 권한 상태가 결정된 후 Amplitude 초기화
        AmplitudeManager.shared.loadAmplitude()
        let userId = authManager.currentUser?.userId
        AmplitudeManager.shared.setUserId(userId)
    }
    
    // MARK: - 리뷰 유도 팝업 관련
    
    
    // 리뷰유도팝업 - 열수있나 확인하기
    func checkShowReviewPopup(){
        Task {
            let canOpen = useCase.checkShowReviewPopup()
            self.showReviewPopup = canOpen
        }
    }
    
    // 리뷰유도팝업 닫기
    func dismissReviewPopup() {
        showReviewPopup = false
    }
    
    // 리뷰유도팝업 - 나중에 할게요
    func delayReviewPopup(day: Int){
        Task {
            useCase.setReviewDelayed(days: day)
        }
    }
}
