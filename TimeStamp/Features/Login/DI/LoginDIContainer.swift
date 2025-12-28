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
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: @escaping () -> Void) -> NicknameSettingView
    func makeTermsWebView(onDismiss: @escaping () -> Void) -> AnyView
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
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: @escaping () -> Void) -> NicknameSettingView {
        let vm = makeNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }

    // MARK: - Terms WebView

    func makeTermsWebView(onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(
            NavigationView {
                AdvancedWebView(
                    url: URL(string: AppConstants.URLs.termsOfService)!,
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
    
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: @escaping () -> Void) -> NicknameSettingView {
        let vm = makeNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }

    func makeTermsWebView(onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(
            NavigationView {
                AdvancedWebView(
                    url: URL(string: AppConstants.URLs.termsOfService)!,
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

    // Mock struct
    
    struct MockLoginUseCase: LoginUseCaseProtocol {
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
}
