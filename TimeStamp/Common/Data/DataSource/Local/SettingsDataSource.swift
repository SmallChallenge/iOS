//
//  SettingsDataSource.swift
//  TimeStamp
//
//  Created by Claude on 12/31/24.
//

import Foundation

/// UserDefaults를 사용하여 설정을 저장/조회하는 DataSource
final class SettingsDataSource: SettingsDataSourceProtocol {

    // MARK: - Methods

    /// 로그 제한 배너를 닫았는지 여부를 조회
    /// - Returns: 닫았으면 true, 아니면 false
    func getIsLogLimitBannerDismissed() -> Bool {
        return AppConfig.shared.isLogLimitBannerDismissed
    }

    /// 로그 제한 배너를 닫았는지 여부를 저장
    /// - Parameter isDismissed: 닫았으면 true, 아니면 false
    func setIsLogLimitBannerDismissed(_ isDismissed: Bool) {
        AppConfig.shared.isLogLimitBannerDismissed = isDismissed
    }

    /// 자동저장 여부 조회 (기본값: true)
    func getIsAutoSave() -> Bool {
        return AppConfig.shared.isAutoSave
    }

    /// 자동저장 여부 설정
    func setIsAutoSave(_ isAutoSave: Bool) {
        AppConfig.shared.isAutoSave = isAutoSave
    }
}
