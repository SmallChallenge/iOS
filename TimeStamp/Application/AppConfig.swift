//
//  AppConfig.swift
//  TimeStamp
//
//  Created by 임주희 on 4/6/26.
//

import Foundation

/// 앱 관련 설정을 관리하는 싱글톤 클래스
final class AppConfig {
    static let shared = AppConfig()
    private init(){}
    
    // MARK: - auth save
    @UserDefaultsValue(key: "isAutoSave", defaultValue: true)
    var isAutoSave: Bool
    
    
    
    // MARK: - 로그 제한 배너를 닫았는지 여부 (닫았으면 true, 아니면 false)
    @UserDefaultsValue(key: "isLogLimitBannerDismissed", defaultValue: false)
    var isLogLimitBannerDismissed: Bool
}
