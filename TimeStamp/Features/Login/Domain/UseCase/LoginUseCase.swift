//
//  LoginUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    func loginWithApple()
    func loginWithKakao()
    func loginWithGoogle()
}

final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    private var appleLogin: SocialLoginProtocol
    private var kakaoLogin: SocialLoginProtocol
    private var googleLogin: SocialLoginProtocol

    weak var delegate: LoginUseCaseDelegate?

    init(
        repository: LoginRepositoryProtocol
    ) {
        self.repository = repository
        self.appleLogin = AppleLogin()
        self.kakaoLogin = KakaoLogin()
        self.googleLogin = GoogleLogin()

        // Delegate 설정
        self.appleLogin.delegate = self
        self.kakaoLogin.delegate = self
        self.googleLogin.delegate = self
    }

    func loginWithApple() {
        appleLogin.login()
    }

    func loginWithKakao() {
        kakaoLogin.login()
    }

    func loginWithGoogle() {
        googleLogin.login()
    }

    // MARK: - Private Methods

    private func performLogin(type: LoginType, accessToken: String) async -> Result<LoginEntity, NetworkError> {
        switch type {
        case .apple:
            return await repository.appleLogin(accessToken: accessToken)
        case .kakao:
            return await repository.kakaoLogin(accessToken: accessToken)
        case .google:
            return await repository.googleLogin(accessToken: accessToken)
        }
    }
}

// MARK: - LoginUseCaseDelegate

protocol LoginUseCaseDelegate: AnyObject {
    func loginUseCase(didStartLoading: Bool)
    func loginUseCase(didReceiveError message: String)
    func loginUseCase(didLoginSuccess entity: LoginEntity)
}

// MARK: - SocialLoginDelegate

extension LoginUseCase: SocialLoginDelegate {
    func didLogin(type: LoginType, didReceiveToken token: String?, error: Error?) {
        guard let token = token else {
            delegate?.loginUseCase(didReceiveError: error?.localizedDescription ?? "로그인 실패")
            return
        }

        delegate?.loginUseCase(didStartLoading: true)

        Task {
            let result = await performLogin(type: type, accessToken: token)

            await MainActor.run {
                delegate?.loginUseCase(didStartLoading: false)

                switch result {
                case .success(let entity):
                    
                    // 로그인 성공 처리 (토큰 + 사용자 정보 저장)
                    let user = User(
                        userId: entity.userId,
                        nickname: entity.nickname,
                        socialType: entity.socialType,
                        profileImageUrl: entity.profileImageUrl
                    )
                    AuthManager.shared.login(
                        user: user,
                        accessToken: entity.accessToken,
                        refreshToken: entity.refreshToken
                    )
                    
                    // TODO: 로그인 성공 처리 (토큰 저장, 화면 전환 등)

                    delegate?.loginUseCase(didLoginSuccess: entity)

                case let .failure(error):
                    let message = error.localizedDescription
                    delegate?.loginUseCase(didReceiveError: message)
                    print(">>>>> \(type.rawValue) 로그인 실패: \(error)")
                }
            }
        }
    }
}
