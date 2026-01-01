//
//  UserDefaultsSettingsDataSourceProtocol.swift
//  TimeStamp
//
//  Created by Claude on 12/31/24.
//

import Foundation

/// 설정 DataSource Protocol (Domain Layer)
protocol UserDefaultsSettingsDataSourceProtocol {
    /// 로그 제한 배너를 닫았는지 여부를 조회
    /// - Returns: 닫았으면 true, 아니면 false
    func getIsLogLimitBannerDismissed() -> Bool

    /// 로그 제한 배너를 닫았는지 여부를 저장
    /// - Parameter isDismissed: 닫았으면 true, 아니면 false
    func setIsLogLimitBannerDismissed(_ isDismissed: Bool)
}
