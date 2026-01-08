//
//  AdMobRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 1/8/26.
//


import Foundation
import UIKit
import GoogleMobileAds

enum AdError: Error {
    case notLoaded
    case cancelled
}

@MainActor
final class AdMobRepository: NSObject, AdRepositoryProtocol {
    private var rewardedAd: RewardedAd?
    // 1. 현재 진행 중인 continuation을 보관합니다.
    private var showAdContinuation: CheckedContinuation<Int, Error>?
    
    func loadRewardedAd() async throws {
        let ad = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<RewardedAd, Error>) in
            RewardedAd.load(with: AppConstants.SDKKeys.ad_reward,
                            request: Request()) { ad, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else if let ad = ad {
                    continuation.resume(returning: ad)
                }
            }
        }
        self.rewardedAd = ad
        self.rewardedAd?.fullScreenContentDelegate = self
    }
    
    func showRewardedAd(fromRootViewController: UIViewController) async throws -> Int {
        guard let ad = rewardedAd else { throw AdError.notLoaded }
        
        return try await withCheckedThrowingContinuation { continuation in
            // 2. 외부에서 참조할 수 있게 보관 (델리게이트에서 응답하기 위함)
            self.showAdContinuation = continuation
            
            ad.present(from: fromRootViewController) {
                // 보상 획득 시점
                let amount = ad.adReward.amount.intValue
                self.showAdContinuation?.resume(returning: amount)
                self.showAdContinuation = nil // 사용 완료 후 초기화
            }
        }
    }
}

extension AdMobRepository: FullScreenContentDelegate {
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            // 3. 표시 실패 시 continuation을 여기서 종료시켜야 "leaked" 에러가 안 납니다.
            showAdContinuation?.resume(throwing: error)
            showAdContinuation = nil
            rewardedAd = nil
        }
        
        func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
            // 보상을 받지 않고 닫았을 경우 처리
            showAdContinuation?.resume(throwing: AdError.cancelled)
            showAdContinuation = nil
            rewardedAd = nil
        }
    
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
      print("\(#function) called")
    }
}
