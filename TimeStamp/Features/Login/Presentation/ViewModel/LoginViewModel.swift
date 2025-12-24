//
//  LoginViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    private let useCase: LoginUseCase

    init(useCase: LoginUseCase) {
        self.useCase = useCase
        self.useCase.delegate = self
    }

    // MARK: - Output Properties

    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Input Methods

    func clickAppleLoginButton() {
        useCase.loginWithApple()
    }

    func clickKakaoLoginButton() {
        useCase.loginWithKakao()
    }

    func clickGoogleLoginButton() {
        useCase.loginWithGoogle()
    }
}

// MARK: - LoginUseCaseDelegate

extension LoginViewModel: LoginUseCaseDelegate {
    func loginUseCase(didStartLoading: Bool) {
        isLoading = didStartLoading
    }

    func loginUseCase(didReceiveError message: String) {
        Logger.error("로그인 실패: \(message)")
        errorMessage = message
    }

    func loginUseCase(didLoginSuccess entity: LoginEntity) {
        Logger.success("로그인 성공: \(entity)")
        // TODO: 로그인 성공 처리 (토큰 저장, 화면 전환 등)
    }
}
