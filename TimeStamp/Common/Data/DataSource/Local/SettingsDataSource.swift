//
//  SettingsDataSource.swift
//  TimeStamp
//
//  Created by Claude on 12/31/24.
//

import Foundation

/// UserDefaults를 사용하여 설정을 저장/조회하는 DataSource
final class SettingsDataSource: SettingsDataSourceProtocol {

    // MARK: - Keys

    private enum Keys {
        // 로그제한배너 닫음 여부
        static let isLogLimitBannerDismissed = "isLogLimitBannerDismissed"
        
        // 자동저장 설정값
        static let isAutoSave = "isAutoSave"
    }

    // MARK: - Properties

    private let userDefaults: UserDefaults

    // MARK: - Init

    /// DataSource 초기화
    /// - Parameter userDefaults: UserDefaults 인스턴스 (기본값: .standard)
    /// - Note: 테스트 시 다른 UserDefaults를 주입할 수 있음
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - Methods

    /// 로그 제한 배너를 닫았는지 여부를 조회
    /// - Returns: 닫았으면 true, 아니면 false
    func getIsLogLimitBannerDismissed() -> Bool {
        return userDefaults.bool(forKey: Keys.isLogLimitBannerDismissed)
    }

    /// 로그 제한 배너를 닫았는지 여부를 저장
    /// - Parameter isDismissed: 닫았으면 true, 아니면 false
    func setIsLogLimitBannerDismissed(_ isDismissed: Bool) {
        userDefaults.set(isDismissed, forKey: Keys.isLogLimitBannerDismissed)
    }

    /// 자동저장 여부 조회 (기본값: true)
    func getIsAutoSave() -> Bool {
        if userDefaults.object(forKey: Keys.isAutoSave) == nil {
            return true
        }
        return userDefaults.bool(forKey: Keys.isAutoSave)
    }

    /// 자동저장 여부 설정
    func setIsAutoSave(_ isAutoSave: Bool) {
        userDefaults.set(isAutoSave, forKey: Keys.isAutoSave)
    }
}
