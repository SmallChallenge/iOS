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

public final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    private var appleLogin: SocialLoginProtocol
    private var kakaoLogin: SocialLoginProtocol
    private var googleLogin: SocialLoginProtocol

    weak var delegate: LoginUseCaseDelegate?

    public init(
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

    private func performLogin(type: LoginType, accessToken: String) async -> Result<ResponseBody<LoginResponseDto>, NetworkError> {
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
    func loginUseCase(didLoginSuccess response: LoginResponseDto)
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
                case .success(let response):
                    guard let dto = response.data else {
                        delegate?.loginUseCase(didReceiveError: "data is nil")
                        return
                    }
                    // TODO: dto to entity
                    delegate?.loginUseCase(didLoginSuccess: dto)
                    
                case let .failure(error):
                    let message = error.localizedDescription
                    delegate?.loginUseCase(didReceiveError: message)
                    print(">>>>> 로그인 실패: \(error)")
                }
            }
        }
    }
}
