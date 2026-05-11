//
//  StoreRatingsManager.swift
//  TimeStamp
//
//  Created by 임주희 on 4/30/26.
//

import Foundation
import StoreKit

/*
 유저가 앱을 설치하고 최소 3회 이상 사진을 저장했을 때, 저장 직후 로직 작동
 이미 설치 후 3회 이상 사진을 촬영한 사람은 1회 저장 완료되면 로직 작동
 
 */

public class StoreRatingsManager {
    // Date값을 String으로 변환해서 저장하기 (포맷 "yyyy-MM-dd HH:mm")
    @UserDefaultsValue(key: "StoreRatingsDate", defaultValue: "")
    private var targetDate: String
    
    // 사진 저장회수를 String으로 변환해서 저장
    @Keychain(key: "totalLogCount")
    private var logCount: String?

    public init() {}

    // days 이후에 뜨게하기
    public func setDelayed(days: Int) {
        guard NetworkConfig.environment == .prod else {
            // Dev 버전이면 무조건 5분뒤로 설정
            setDelayedForDev()
            return
        }

        let today = Date()
        if let target = Calendar.current.date(byAdding: .day, value: days, to: today) {
            targetDate = target.toString(format: "yyyy-MM-dd HH:mm")
        }
    }

    /// Dev 버전이면 무조건 5분뒤로 설정
    private func setDelayedForDev() {
        let today = Date()
        if let target = Calendar.current.date(byAdding: .minute, value: 5, to: today) {
            targetDate = target.toString(format: "yyyy-MM-dd HH:mm")
        }
    }
    
    
    /// 사진 저장 개수 +1 하기
    public func updateLogCount() {
        var count = if let logCount {
            Int(logCount) ?? 0
        } else {
            0
        }
        
        count += 1
        
        logCount = "\(count)"
        
        Logger.debug("updated logCount : \(logCount ?? "")")
    }

    /// 저장된 날짜가 지났는지 안지났는지 확인 && logCount 개수가 3개 이상
    /// - Returns: 저장된 날짜가 없으면 true 반환, 저장된 날짜가 있으면 해당 날짜가 지난 경우에 true 지나지 않은 경우 false
    public func canOpen() -> Bool {
       
        let today = Date()
        // 저장된 날짜가 없으면 true 반환,
        // 저장된 날짜가 있으면 해당 날짜가 지난 경우에 true 지나지 않은 경우 false
        let isAfterTargetDate = if let target = targetDate.toDate(format: "yyyy-MM-dd HH:mm"){
            today > target
        } else {
            true
        }
        
        
        Logger.debug("isAfterTargetDate : \(isAfterTargetDate)")
        Logger.debug("logCount : \(logCount ?? "")")
        print(">>>>> isAfterTargetDate : \(isAfterTargetDate)")
        print(">>>>> logCount : \(logCount ?? "")")
        
        // 로그개수, 가져올 수 없으면 기본값 0
        let count = if let logCount {
            Int(logCount) ?? 0
        } else {
            0
        }
        
        return isAfterTargetDate && (count >= 3)
    }

    /// 앱스토어 리뷰 요청하기
    public func requestReview() {
        let url = "https://apps.apple.com/app/id6756785730?action=write-review"
        guard let writeReviewURL = URL(string: url) else {
            Logger.error("Expected a valid URL")
            fatalError("Expected a valid URL")
        }
        let application = UIApplication.shared
        application.open(writeReviewURL, options: [:], completionHandler: nil)
    }

    /// 앱 평가 요청하기
    public func requestRatings() {
        print(">>>>> requestRatings ")
        guard canOpen() else { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
