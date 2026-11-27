//
//  MyPageDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
protocol MyPageDIContainerProtocol {
    func makeMyPageView(onGoBack: @escaping () -> Void) -> MyPageView
    func makeUserInfoPageView(onGoBack: @escaping () -> Void, onSignOutCompleted: @escaping () -> Void) -> UserInfoPageView
    
}
final class MyPageDIContainer: MyPageDIContainerProtocol {

    // MARK: - Dependencies
    private let authApiClient: AuthApiClientProtocol
    private let settingsDataSource: SettingsDataSourceProtocol

    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol, settingsDataSource: SettingsDataSourceProtocol, authManager: AuthManager) {
        self.authApiClient = authApiClient
        self.settingsDataSource = settingsDataSource
        self.authManager = authManager
    }
    
    // MARK: - Auth
    private let authManager: AuthManager
    
    lazy var authStateProvider: AuthStateProviding = {
        authManager
    }()
    
    lazy var tokenStorage: TokenStoring = {
        authManager
    }()

    // MARK: - MyPageView
    private func makeLogoutRepository() -> LogoutRepositoryProtocol {
        LogoutRepository(authApiClient: authApiClient)
    }

    private func makeMyPageUseCase() -> MyPageUseCaseProtocol {
        let logoutRepository = makeLogoutRepository()
        return MyPageUseCase(logoutRepository: logoutRepository, settingsRepository: settingsDataSource)
    }

    private func makeMyPageViewModel() -> MyPageViewModel {
        let useCase = makeMyPageUseCase()
        return MyPageViewModel(useCase: useCase, authStateProvider: authStateProvider)
    }

    func makeMyPageView(onGoBack: @escaping () -> Void) -> MyPageView {
        let vm = makeMyPageViewModel()
        return MyPageView(viewModel: vm, diContainer: self, onGoBack: onGoBack)
    }
    // MARK: - UseInfoPageView
    private func makeUserInfoRepository() -> UserInfoRepositoryProtocol {
        UserInfoRepository(authApiClient: authApiClient)
    }

    private func makeWithdrawalUseCase() -> WithdrawalUseCaseProtocol {
        let repository = makeUserInfoRepository()
        return WithdrawalUseCase(repository: repository)
    }

    private func makeUserInfoPageViewModel() -> UserInfoPageViewModel {
        let useCase = makeWithdrawalUseCase()
        return UserInfoPageViewModel(withdrawalUseCase: useCase)
    }

    func makeUserInfoPageView(onGoBack: @escaping () -> Void, onSignOutCompleted: @escaping () -> Void) -> UserInfoPageView {
        let viewModel = makeUserInfoPageViewModel()
        return UserInfoPageView(viewModel: viewModel, onGoBack: onGoBack, onSignOutCompleted: onSignOutCompleted)
    }
}
struct MockMyPageDIContainer: MyPageDIContainerProtocol{
    func makeMyPageView(onGoBack: @escaping () -> Void) -> MyPageView {
        let useCase = MockMyPageUseCase()
        let vm = MyPageViewModel(useCase: useCase, authStateProvider: MockAuthStateProvider())
        return MyPageView(viewModel: vm, diContainer: self, onGoBack: onGoBack)
    }

    func makeUserInfoPageView(onGoBack: @escaping () -> Void, onSignOutCompleted: @escaping () -> Void) -> UserInfoPageView {
        let useCase = MockWithdrawalUseCase()
        let viewModel = UserInfoPageViewModel(withdrawalUseCase: useCase)
        return UserInfoPageView(viewModel: viewModel, onGoBack: onGoBack, onSignOutCompleted: onSignOutCompleted)
    }

    struct MockMyPageUseCase: MyPageUseCaseProtocol {
        func logout() async throws {}
        func getIsLogLimitBannerDismissed() -> Bool { false }
        func setIsLogLimitBannerDismissed(_ isDismissed: Bool) {}
        func isAutoSaveEnabled() -> Bool { true }
        func setAutoSaveEnabled(_ isEnabled: Bool) {}
        func getLaunchCameraOnStart() -> Bool { false }
        func updateLaunchCameraOnStart(_ shouldLaunchCameraOnStart: Bool) {}
    }

    struct MockWithdrawalUseCase: WithdrawalUseCaseProtocol {
        func withdrawal() async throws {}
    }
}
