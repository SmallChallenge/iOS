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
    func makeNicknameSettingView(loginEntity: LoginEntity?, onGoBack: @escaping (_ needRefresh: Bool) -> Void, onDismiss: (()-> Void)?) -> NicknameSettingView
    func makeTermsView(loginEntity: LoginEntity?, onDismiss: @escaping (_ isActive: Bool) -> Void) -> TermsView
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
    
    private func makeNicknameSettingViewModel(loginEntity: LoginEntity?) -> NicknameSettingViewModel {
        let usecase = makeNicknameSettingUseCase()
        return NicknameSettingViewModel(useCase: usecase, pendingLoginEntity: loginEntity)
        
    }
    func makeNicknameSettingView(loginEntity: LoginEntity?, onGoBack: @escaping (_ needRefresh: Bool) -> Void, onDismiss: (()-> Void)?) -> NicknameSettingView {
        let vm = makeNicknameSettingViewModel(loginEntity: loginEntity)
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
    
    private func makeTermsViewModel(loginEntity: LoginEntity?) -> TermsViewModel {
        let usecase = makeTermsUseCase()
        return TermsViewModel(usecase: usecase, pendingLoginEntity: loginEntity)
    }
    
    func makeTermsView(loginEntity: LoginEntity?, onDismiss: @escaping (_ isActive: Bool) -> Void) -> TermsView {
        let vm = makeTermsViewModel(loginEntity: loginEntity)
        return TermsView(viewModel: vm, diContainer: self, onDismiss: onDismiss)
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
   
    // MARK: Login
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
        return NicknameSettingViewModel(useCase: makeNicknameSettingUseCase(), pendingLoginEntity: nil)
    }
    
    func makeNicknameSettingView(loginEntity: LoginEntity?, onGoBack: @escaping (Bool) -> Void, onDismiss: (() -> Void)?) -> NicknameSettingView {
        let vm = makeNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }
    
   
    // MARK: - web view

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
    
    // MARK:  TermsView
    func makeTermsView(loginEntity: LoginEntity?, onDismiss: @escaping (Bool) -> Void) -> TermsView {
        let useCase = MockTermsUseCase()
        let entity = LoginEntity(userId: 0, nickname: nil, socialType: .kakao, profileImageUrl: nil, accessToken: "", refreshToken: "", isNewUser: true, status: .pending, needNickname: true)
        let vm = TermsViewModel(usecase: useCase, pendingLoginEntity: entity)
        return TermsView(viewModel: vm, diContainer: self, onDismiss: {_ in })
    }

    // -------- Mock struct ------ //
    
    struct MockLoginUseCase: LoginUseCaseProtocol {
        func cancelLogin(entity: LoginEntity) async throws {}
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
        func login(entity: LoginEntity) {}
        
        func setNickname(nickname: String ,accessToken: String?) async throws -> NicknameEntity {
            NicknameEntity(userId: 1, nickname: "닉네임", isProfileComplete: true)
        }
    }
    struct MockTermsUseCase: TermsUseCaseProtocol {
        func activeAccount(accessToken token: String, agreedToPrivacyPolicy: Bool, agreedToTermsOfService: Bool, agreedToMarketing: Bool) async throws -> ActiveAccount {
            throw NetworkError.dataNil
        }
    }
}
