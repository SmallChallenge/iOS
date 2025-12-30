//
//  LoginViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject, MessageDisplayable {
    private let useCase: LoginUseCaseProtocol

    init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Output Properties
    
    @Published var needNickname = false
    @Published var needTerms = false
    /// 로그인 성공여부
    @Published var isLoggedIn = false
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    // MARK: - Private Properties

    /// 약관 완료 후 닉네임 체크를 위해 저장
    private(set) var pendingLoginEntity: LoginEntity?

    // MARK: - Input Methods

    func clickAppleLoginButton() {
        guard !isLoading else { return }
        Task {
            await performLogin { try await useCase.loginWithApple() }
        }
    }

    func clickKakaoLoginButton() {
        guard !isLoading else { return }
        Task {
            await performLogin { try await useCase.loginWithKakao() }
        }
    }

    func clickGoogleLoginButton() {
        guard !isLoading else { return }
        Task {
            await performLogin { try await useCase.loginWithGoogle() }
        }
    }

    /// 약관 완료 후 호출
    func onTermsCompleted() {
        guard let entity = pendingLoginEntity else { return }
        
        // 로그인하기
        useCase.login(entity: entity)
        
        if entity.needNickname {
            // 약관 완료 후 닉네임 필요하면 닉네임 화면으로
            needNickname = true
        } else {
            // 모든 절차 완료
            isLoggedIn = true
        }
        pendingLoginEntity = nil
    }

    // MARK: - Private Methods
    
    private func clearData(){
        pendingLoginEntity = nil
        needNickname = false
        needTerms = false
        isLoggedIn = false
    }

    // 로그인 공통
    @MainActor
    private func performLogin(_ loginAction: () async throws -> LoginEntity) async {
        isLoading = true
        clearData()

        do {
            let entity = try await loginAction()
            Logger.success("로그인 성공: \(entity)")
            
            await MainActor.run {
                isLoading = false
                // 신규회원, 약관 화면으로 이동
                if entity.isNewUser {
                    pendingLoginEntity = entity  // 저장해두고 약관 완료 후 체크
                    needTerms = true
                    return
                } else if entity.needNickname {
                    // 닉네임 입력화면으로 보내기.
                    needNickname = true
                    useCase.login(entity: entity) // 로그인성공
                    return
                }

                // 로그인 성공 시, 로그인 화면 닫기
                // (약관 안받아도 되고, 닉네임도 있음)
                isLoggedIn = true
                useCase.login(entity: entity) // 로그인성공
            }
            
        } catch {
            isLoggedIn = false
            isLoading = false
            show(.loginFailed)
            
            Logger.error("로그인 실패: \(error)")
        }
    }
}
