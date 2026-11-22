//
//  MainTabRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 4/30/26.
//

import Foundation

struct MainTabRepository: MainTabRepositoryProtocol {
    private let reviewManager: StoreRatingsManager

    init() {
        self.reviewManager = StoreRatingsManager()
    }
    
    
    func getCanReviewOpen() -> Bool {
        reviewManager.canOpen()
    }
    
    func setReviewDelayed(days: Int) {
        reviewManager.setDelayed(days: days)
    }
    
    /// 자동저장 여부 조회 (기본값: true)
    func getIsAutoSave() -> Bool {
        return UserSettings.shared.isAutoSave
    }
    
    /// 앱설치후 첫 저장인지 확인 (기본값: true)
    func getIsFirstSave() -> Bool {
        return UserSettings.shared.isFirstSave
    }
    
    /// 첫저장했음
    func setIfFirstSave(_ isFirstSave: Bool) {
        UserSettings.shared.isFirstSave = isFirstSave
    }
    
    /// 자동저장 여부 설정
    func setIsAutoSave(_ isAutoSave: Bool) {
        UserSettings.shared.isAutoSave = isAutoSave
    }
}
