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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var needNickname = false
    @Published var needTerms = false
    @Published var isLoggedIn = false

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
            
            isLoading = false
            // 신구회원, 약관 화면으로 이동
            if entity.isNewUser {
                return
            } else if entity.needNickname {
                // 닉네임 입력화면으로 보내기.
                return
            }
        
            // 로그인 성공 시, 로그인 화면 닫기
            // (약관 안받아도 되고, 닉네임도 있음(
            isLoggedIn = true
            
        } catch {
            Logger.error("로그인 실패: \(error)")
            errorMessage = error.localizedDescription
            isLoggedIn = false
            isLoading = false
        }
    }
}
