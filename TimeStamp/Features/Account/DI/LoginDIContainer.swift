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
    func makeTermsView(loginEntity: LoginEntity?, onDismiss: @escaping (_ isActive: Bool) -> Void) -> TermsView
    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView
    
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: (()-> Void)?, onSuccess: (() -> Void)?) -> NicknameSettingView<NicknameSettingViewModel>
    func makeGuestNicknameSettingView(loginEntity: LoginEntity, onGoBack: @escaping () -> Void, onDismiss: (()-> Void)?, onSuccess: (() -> Void)?) -> NicknameSettingView<GuestNicknameSettingViewModel>
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
    
    
    
    private func makeGuestNicknameSettingViewModel(loginEntity: LoginEntity) -> GuestNicknameSettingViewModel {
        let usecase = makeNicknameSettingUseCase()
        return GuestNicknameSettingViewModel(useCase: usecase, pendingLoginEntity: loginEntity)
        
    }
    private func makeNicknameSettingViewModel() -> NicknameSettingViewModel {
        let usecase = makeNicknameSettingUseCase()
        return NicknameSettingViewModel(useCase: usecase)
    }
    
    /// 닉네임 설정 화면
    /// - Parameters:
    ///   - onGoBack: 로그인 로직에선 그냥 뒤로감, 마이페이지 로직에선 새로고침 여부 보냄
    ///   - onDismiss: 로그인 로직에서, 로그인 뷰 닫기
    ///   - onSuccess: 닉네임 설정 성공 시 호출
    /// - Returns:
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: (()-> Void)?, onSuccess: (() -> Void)?) -> NicknameSettingView<NicknameSettingViewModel> {
        let vm = makeNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss,
            onSuccess: onSuccess
        )
    }
    
    /// 회원가입 전, 닉네임세팅
    /// - Parameters:
    ///   - onGoBack: 로그인 로직에선 그냥 뒤로감, 마이페이지 로직에선 새로고침 여부 보냄
    ///   - onDismiss: 로그인 로직에서, 로그인 뷰 닫기
    ///   - onSuccess: 닉네임 설정 성공 시 호출
    /// - Returns:
    func makeGuestNicknameSettingView(loginEntity: LoginEntity, onGoBack: @escaping () -> Void, onDismiss: (()-> Void)?, onSuccess: (() -> Void)?) -> NicknameSettingView<GuestNicknameSettingViewModel> {
        let vm = makeGuestNicknameSettingViewModel(loginEntity: loginEntity)
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss,
            onSuccess: onSuccess
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
        return NicknameSettingViewModel(useCase: makeNicknameSettingUseCase())
    }
    private func makeGuestNicknameSettingViewModel() -> GuestNicknameSettingViewModel {
        return GuestNicknameSettingViewModel(useCase: makeNicknameSettingUseCase(), pendingLoginEntity: LoginEntity(userId: 0, nickname: nil, socialType: .apple, profileImageUrl: nil, accessToken: "", refreshToken: "", isNewUser: true, status: .pending, needNickname: true))
    }
    
    func makeNicknameSettingView(onGoBack: @escaping () -> Void, onDismiss: (() -> Void)?, onSuccess: (() -> Void)?) -> NicknameSettingView<NicknameSettingViewModel> {
        let vm = makeNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss,
            onSuccess: onSuccess
        )
    }
    
    func makeGuestNicknameSettingView(loginEntity: LoginEntity, onGoBack: @escaping () -> Void, onDismiss: (() -> Void)?, onSuccess: (() -> Void)?) -> NicknameSettingView<GuestNicknameSettingViewModel> {
        let vm = makeGuestNicknameSettingViewModel()
        return NicknameSettingView(
            viewModel: vm,
            onGoBack: onGoBack,
            onDismiss: onDismiss,
            onSuccess: onSuccess
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
        
        func updateUserInfo(nickname: String) {
            
        }
        
        func login(entity: LoginEntity) {}
        
        func setNickname(nickname: String) async throws -> NicknameEntity {
            NicknameEntity(userId: 1, nickname: "닉네임", isProfileComplete: true)
        }
        
        func setGuestNickname(nickname: String, accessToken: String) async throws -> NicknameEntity {
            NicknameEntity(userId: 1, nickname: "닉네임", isProfileComplete: true)
        }
        
    }
    struct MockTermsUseCase: TermsUseCaseProtocol {
        func activeAccount(accessToken token: String, agreedToPrivacyPolicy: Bool, agreedToTermsOfService: Bool, agreedToMarketing: Bool) async throws -> ActiveAccountEntity {
            throw NetworkError.dataNil
        }
    }
}
