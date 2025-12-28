//
//  LoginViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    private let useCase: LoginUseCaseProtocol

    init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Output Properties

    /// 로그인 성공여부
    @Published var isLoggedIn = false
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Input Methods

    func clickAppleLoginButton() {
        Task {
            await performLogin { try await useCase.loginWithApple() }
        }
    }

    func clickKakaoLoginButton() {
        Task {
            await performLogin { try await useCase.loginWithKakao() }
        }
    }

    func clickGoogleLoginButton() {
        Task {
            await performLogin { try await useCase.loginWithGoogle() }
        }
    }

    // MARK: - Private Methods

    @MainActor
    private func performLogin(_ loginAction: () async throws -> LoginEntity) async {
        isLoading = true
        errorMessage = nil

        do {
            let entity = try await loginAction()
            Logger.success("로그인 성공: \(entity)")
            isLoggedIn = true
            isLoading = false
        } catch {
            Logger.error("로그인 실패: \(error)")
            errorMessage = error.localizedDescription
            isLoggedIn = false
            isLoading = false
        }
    }
}
