//
//  AdManager.swift
//  Stampic
//
//  Created by 임주희 on 1/8/26.
//

import Foundation
import GoogleMobileAds

protocol RewardedAdAction {
    func showRewardedAd()
}
protocol AdManagerProtocol: RewardedAdAction {
    
}
final class AdManager: AdManagerProtocol {
    func showRewardedAd() {
        
    }
}

