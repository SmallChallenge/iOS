//
//  LoginUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    func loginWithApple() async throws -> LoginEntity
    func loginWithKakao() async throws -> LoginEntity
    func loginWithGoogle() async throws -> LoginEntity
    
    func login(entity: LoginEntity)
}

// MARK: LoginUseCase
final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    private var appleLogin: SocialLoginProtocol
    private var kakaoLogin: SocialLoginProtocol
    private var googleLogin: SocialLoginProtocol

    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
        self.appleLogin = AppleLogin()
        self.kakaoLogin = KakaoLogin()
        self.googleLogin = GoogleLogin()
    }

    func loginWithApple() async throws -> LoginEntity {
        return try await performSocialLogin(type: .apple, socialLogin: appleLogin)
    }

    func loginWithKakao() async throws -> LoginEntity {
        return try await performSocialLogin(type: .kakao, socialLogin: kakaoLogin)
    }

    func loginWithGoogle() async throws -> LoginEntity {
        return try await performSocialLogin(type: .google, socialLogin: googleLogin)
    }

    // MARK: - Private Methods

    private func performSocialLogin(type: LoginType, socialLogin: SocialLoginProtocol) async throws -> LoginEntity {
        // SocialLogin의 Delegate 콜백을 async로 변환
        let token = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            var tempSocialLogin = socialLogin
            tempSocialLogin.delegate = SocialLoginDelegateWrapper(continuation: continuation)
            tempSocialLogin.login()
        }

        // 서버 로그인 처리
        let result = await performLogin(type: type, accessToken: token)

        switch result {
        case .success(let entity):
            
            return entity

        case .failure(let error):
            throw error
        }
    }
    
    // 로그인 성공 처리 (토큰 + 사용자 정보 저장)
    func login(entity: LoginEntity){
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
    }

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

// MARK: - SocialLoginDelegateWrapper

private class SocialLoginDelegateWrapper: SocialLoginDelegate {
    private let continuation: CheckedContinuation<String, Error>
    private var hasResumed = false

    init(continuation: CheckedContinuation<String, Error>) {
        self.continuation = continuation
    }

    func didLogin(type: LoginType, didReceiveToken token: String?, error: Error?) {
        guard !hasResumed else { return }
        hasResumed = true

        if let error = error {
            continuation.resume(throwing: error)
        } else if let token = token {
            continuation.resume(returning: token)
        } else {
            continuation.resume(throwing: NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 실패"]))
        }
    }
}
