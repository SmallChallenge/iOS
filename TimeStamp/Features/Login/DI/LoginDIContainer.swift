//
//  LoginDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation
import SwiftUI

protocol LoginDIContainerProtocol {
    func makeLoginView(onDismiss: @escaping () -> Void) -> LoginView
    func makeNicknameSettingView(onGoBack: @escaping (_ needRefresh: Bool) -> Void, onDismiss: (()-> Void)?) -> NicknameSettingView
    func makeTermsView(accessToken token: String?, onDismiss: @escaping (_ isActive: Bool) -> Void) -> TermsView
    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView
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
    
    private func makeNicknameSettingRepository() -> NicknameSettingRepositoryProtocol {
        return NicknameSettingRepository(authApiClient: authApiClient)
    }
    
    private func makeNicknameSettingUseCase() -> NicknameSettingUseCaseProtocol {
        let repo = makeNicknameSettingRepository()
        return NicknameSettingUseCase(repository: repo)
    }
    
    private func makeNicknameSettingViewModel() -> NicknameSettingViewModel {
        let usecase = makeNicknameSettingUseCase()
        return NicknameSettingViewModel(useCase: usecase)
        
    }
    func makeNicknameSettingView(onGoBack: @escaping (_ needRefresh: Bool) -> Void, onDismiss: (()-> Void)?) -> NicknameSettingView {
        let vm = makeNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }
    
    // MARK: - Terms
    private func makeTermsRepository() -> TermsRepositoryProtocol {
        TermsRepository(authApiClient: authApiClient)
    }
    private func makeTermsUseCase() -> TermsUseCaseProtocol {
        let repo = makeTermsRepository()
        return TermsUseCase(repository: repo )
    }
    
    private func makeTermsViewModel() -> TermsViewModel {
        let usecase = makeTermsUseCase()
        return TermsViewModel(usecase: usecase)
    }
    
    func makeTermsView(accessToken token: String?, onDismiss: @escaping (_ isActive: Bool) -> Void) -> TermsView {
        let vm = makeTermsViewModel()
        return TermsView(viewModel: vm, diContainer: self, accessToken: token, onDismiss: onDismiss)
    }

    // MARK: - Terms WebView

    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(
            NavigationStack {
                AdvancedWebView(
                    url: URL(string: url)!,
                    isLoading: .constant(false)
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        )
    }
}

// MARK: - Mock


final class MockLoginDIContainer: LoginDIContainerProtocol {
    private func makeLoginUseCase() -> LoginUseCaseProtocol {
        return MockLoginUseCase()
    }
    private func makeLoginViewModel() -> LoginViewModel {
        LoginViewModel(useCase: makeLoginUseCase())
    }
    func makeLoginView(onDismiss: @escaping () -> Void) -> LoginView {
        let viewModel = makeLoginViewModel()
        return LoginView(viewModel: viewModel, diContainer: self, onDismiss: {})
    }
    
    // MARK: NicknameSettingView
    
    private func makeNicknameSettingUseCase() -> NicknameSettingUseCaseProtocol {
        return MockNicknameSettingUseCase()
    }
    
    private func makeNicknameSettingViewModel() -> NicknameSettingViewModel {
        return NicknameSettingViewModel(useCase: makeNicknameSettingUseCase())
    }
    
    func makeNicknameSettingView(onGoBack: @escaping (_ needRefresh: Bool) -> Void, onDismiss: (()-> Void)?) -> NicknameSettingView {
        let vm = makeNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }

    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(
            NavigationStack {
                AdvancedWebView(
                    url: URL(string: url)!,
                    isLoading: .constant(false)
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        )
    }

    func makeTermsView(accessToken token: String?, onDismiss: @escaping (_ isActive: Bool) -> Void) -> TermsView {
        let useCase = MockTermsUseCase()
        let vm = TermsViewModel(usecase: useCase)
        return TermsView(viewModel: vm, diContainer: self, accessToken: token, onDismiss: {_ in })
    }

    // -------- Mock struct ------ //
    
    struct MockLoginUseCase: LoginUseCaseProtocol {
        func login(entity: LoginEntity) {}
        
        func loginWithApple() async throws -> LoginEntity {
            throw NetworkError.dataNil
        }
        
        func loginWithKakao() async throws -> LoginEntity {
            throw NetworkError.dataNil
        }
        
        func loginWithGoogle() async throws -> LoginEntity {
            throw NetworkError.dataNil
        }
    }
    
    struct MockNicknameSettingUseCase: NicknameSettingUseCaseProtocol {
        func setNickname(nickname: String) async throws -> NicknameEntity {
            NicknameEntity(userId: 1, nickname: "닉네임", isProfileComplete: true)
        }
    }
    struct MockTermsUseCase: TermsUseCaseProtocol {
        func activeAccount(accessToken token: String, agreedToPrivacyPolicy: Bool, agreedToTermsOfService: Bool, agreedToMarketing: Bool) async throws -> ActiveAccount {
            throw NetworkError.dataNil
        }
    }
}
