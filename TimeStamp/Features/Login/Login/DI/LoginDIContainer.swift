//
//  LoginDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation

protocol LoginDIContainerProtocol {
    func makeLoginView(onDismiss: @escaping () -> Void) -> LoginView
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: @escaping () -> Void) -> NicknameSettingView 
}

final class LoginDIContainer: LoginDIContainerProtocol {

    // MARK: - Dependencies

    private let authApiClient: AuthApiClientProtocol

    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    // MARK: - Repository

    private func makeLoginRepository() -> LoginRepositoryProtocol {
        return LoginRepository(authApiClient: authApiClient)
    }

    // MARK: - UseCase

    private func makeLoginUseCase() -> LoginUseCase {
        return LoginUseCase(repository: makeLoginRepository())
    }

    // MARK: - ViewModel

    private func makeLoginViewModel() -> LoginViewModel {
        return LoginViewModel(useCase: makeLoginUseCase())
    }

    // MARK: - View

    func makeLoginView(onDismiss: @escaping () -> Void) -> LoginView {
        let viewModel = makeLoginViewModel()
        return LoginView(viewModel: viewModel, diContainer: self, onDismiss: onDismiss)
    }
    
    // MARK: -- 닉네임 설정
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: @escaping () -> Void) -> NicknameSettingView {
        NicknameSettingView(
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }
}
