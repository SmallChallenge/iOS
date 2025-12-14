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
    private var appleLogin: SocialLoginProtocol
    private var kakaoLogin: SocialLoginProtocol?
    private var googleLogin: SocialLoginProtocol?

    init(
        useCase: LoginUseCaseProtocol,
        appleLogin: SocialLoginProtocol = AppleLogin(),
        kakaoLogin: SocialLoginProtocol? = nil,
        googleLogin: SocialLoginProtocol? = nil
    ) {
        self.useCase = useCase
        self.appleLogin = appleLogin
        self.kakaoLogin = kakaoLogin
        self.googleLogin = googleLogin

        // Delegate 설정
        self.appleLogin.delegate = self
        self.kakaoLogin?.delegate = self
        self.googleLogin?.delegate = self
    }

    // MARK: Output Properties...

    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: Input Methods...

    func clickAppleLoginButton() {
        appleLogin.login()
    }

    func clickKakaoLoginButton() {
        kakaoLogin?.login()
    }

    func clickGoogleLoginButton() {
        googleLogin?.login()
    }
}

// MARK: - SocialLoginDelegate

extension LoginViewModel: SocialLoginDelegate {
    func didLogin(type: LoginType, didReceiveToken token: String?, error: Error?) {
        guard let token = token else {
            errorMessage = error?.localizedDescription ?? "로그인 실패"
            return
        }
        print(">>>>> token: \(token)")
        isLoading = true

        Task {
            let result: Result<LoginResponseDto, NetworkError>

            switch type {
            case .kakao:
                // TODO: Implement kakao login
                result = .failure(.dataNil)
//                result = await useCase.kakaoLogin(accessToken: token)
            case .google:
                // TODO: Implement google login
                result = .failure(.dataNil)
//                result = await useCase.googleLogin(accessToken: token)
            case .apple:
                result = await useCase.appleLogin(accessToken: token)
            }

            await MainActor.run {
                isLoading = false

                switch result {
                case .success(let response):
                    print(">>>>> 로그인 성공: \(response)")
                    // TODO: 로그인 성공 처리 (토큰 저장, 화면 전환 등)
                case let .failure(error):
                    errorMessage = error.localizedDescription
                    print(">>>>> 로그인 실패: \(error)")
                }
            }
        }
    }
}
