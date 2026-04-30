//
//  StoreRatingsManager.swift
//  TimeStamp
//
//  Created by 임주희 on 4/30/26.
//

import Foundation
import StoreKit

public class StoreRatingsManager {
    // Date값을 String으로 변환해서 저장하기 (포맷 "yyyy-MM-dd HH:mm")
    @UserDefaultsValue(key: "StoreRatingsDate", defaultValue: "")
    private var targetDate: String

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

    /// 저장된 날짜가 지났는지 안지났는지 확인
    /// - Returns: 저장된 날짜가 없으면 true 반환, 저장된 날짜가 있으면 해당 날짜가 지난 경우에 true 지나지 않은 경우 false
    public func canOpen() -> Bool {
        guard let target = targetDate.toDate(format: "yyyy-MM-dd HH:mm") else {
            return true
        }
        let today = Date()
        return today > target
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
        guard canOpen() else { return }
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
