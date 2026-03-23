//
//  MyPageUseCase.swift
//  TimeStamp
//
//  Created by Claude on 3/23/26.
//

import Foundation

/// 마이페이지 UseCase 구현체
final class MyPageUseCase: MyPageUseCaseProtocol {

    // MARK: - Properties

    private let logoutRepository: LogoutRepositoryProtocol
    private let settingsRepository: SettingsDataSourceProtocol

    // MARK: - Init

    init(logoutRepository: LogoutRepositoryProtocol, settingsRepository: SettingsDataSourceProtocol) {
        self.logoutRepository = logoutRepository
        self.settingsRepository = settingsRepository
    }

    // MARK: - Methods

    func logout() async throws {
        try await logoutRepository.logout()
    }

    func getIsLogLimitBannerDismissed() -> Bool {
        return settingsRepository.getIsLogLimitBannerDismissed()
    }

    func setIsLogLimitBannerDismissed(_ isDismissed: Bool) {
        settingsRepository.setIsLogLimitBannerDismissed(isDismissed)
    }

    func isAutoSaveEnabled() -> Bool {
        return settingsRepository.getIsAutoSave()
    }

    func setAutoSaveEnabled(_ isEnabled: Bool) {
        settingsRepository.setIsAutoSave(isEnabled)
    }
}
