//
//  MyPageUseCaseProtocol.swift
//  TimeStamp
//
//  Created by Claude on 3/23/26.
//

import Foundation

/// 마이페이지 UseCase Protocol (Domain Layer)
protocol MyPageUseCaseProtocol {
    /// 로그아웃
    func logout() async throws

    /// 로그 제한 배너를 닫았는지 여부를 조회
    func getIsLogLimitBannerDismissed() -> Bool

    /// 로그 제한 배너를 닫았는지 여부를 저장
    func setIsLogLimitBannerDismissed(_ isDismissed: Bool)

    /// 자동저장 활성화 여부 조회 (기본값: true)
    func isAutoSaveEnabled() -> Bool

    /// 자동저장 활성화 여부 설정
    func setAutoSaveEnabled(_ isEnabled: Bool)
}
