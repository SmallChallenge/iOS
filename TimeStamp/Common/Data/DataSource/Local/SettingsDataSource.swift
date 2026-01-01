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
        static let isLogLimitBannerDismissed = "isLogLimitBannerDismissed"
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

    func getIsLogLimitBannerDismissed() -> Bool {
        return userDefaults.bool(forKey: Keys.isLogLimitBannerDismissed)
    }

    func setIsLogLimitBannerDismissed(_ isDismissed: Bool) {
        userDefaults.set(isDismissed, forKey: Keys.isLogLimitBannerDismissed)
    }
}
