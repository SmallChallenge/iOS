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
    
    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    // MARK: - MyPageView
    private func makeLogoutRepository() -> LogoutRepositoryProtocol {
        LogoutRepository(authApiClient: authApiClient)
    }

    private func makeLogoutUseCase() -> LogoutUseCaseProtocol {
        let repository = makeLogoutRepository()
        return LogoutUseCase(repository: repository)
    }

    private func makeMyPageViewModel() -> MyPageViewModel {
        let useCase = makeLogoutUseCase()
        return MyPageViewModel(logoutUseCase: useCase)
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
        let logoutUseCase = MockLogoutUseCase()
        let vm = MyPageViewModel(logoutUseCase: logoutUseCase)
        return MyPageView(viewModel: vm, diContainer: self, onGoBack: onGoBack)
    }

    func makeUserInfoPageView(onGoBack: @escaping () -> Void, onSignOutCompleted: @escaping () -> Void) -> UserInfoPageView {
        let useCase = MockWithdrawalUseCase()
        let viewModel = UserInfoPageViewModel(withdrawalUseCase: useCase)
        return UserInfoPageView(viewModel: viewModel, onGoBack: onGoBack, onSignOutCompleted: onSignOutCompleted)
    }

    struct MockLogoutUseCase: LogoutUseCaseProtocol {
        func logout() async throws {}
    }

    struct MockWithdrawalUseCase: WithdrawalUseCaseProtocol {
        func withdrawal() async throws {}
    }
}
