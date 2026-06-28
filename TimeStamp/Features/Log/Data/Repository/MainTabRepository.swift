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
}
