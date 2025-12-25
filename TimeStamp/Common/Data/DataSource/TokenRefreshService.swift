//
//  TokenRefreshService.swift
//  TimeStamp
//
//  Created by 임주희 on 12/25/25.
//


import Foundation
import Alamofire

/// 토큰 갱신 전담 서비스
final class TokenRefreshService {

    private let authApiClient: AuthApiClientProtocol
    private var isRefreshing = false
    private var pendingCompletions: [(Bool) -> Void] = []

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    /// 토큰 갱신 시도
    /// - Parameter completion: 성공(true) 또는 실패(false) 반환
    func refreshToken(completion: @escaping (Bool) -> Void) {
        // 이미 갱신 중이면 대기열에 추가
        if isRefreshing {
            pendingCompletions.append(completion)
            return
        }

        // refreshToken 확인
        guard let refreshToken = AuthManager.shared.getRefreshToken() else {
            completion(false)
            return
        }

        isRefreshing = true

        Task { [weak self] in
            guard let self = self else {
                completion(false)
                return
            }

            let result = await authApiClient.refreshToken(refreshToken: refreshToken)

            let success: Bool

            switch result {
            case .success(let response):
                if let accessToken = response.data?.accessToken,
                   let refreshToken = response.data?.refreshToken {
                    // 새 토큰 저장
                    AuthManager.shared.refreshToken(
                        accessToken: accessToken,
                        refreshToken: refreshToken
                    )
                    success = true
                } else {
                    // 토큰 갱신 실패 시 로그아웃 처리
                    AuthManager.shared.logout()
                    success = false
                }

            case .failure(let error):
                Logger.error("토큰 갱신 실패: \(error)")
                // 토큰 갱신 실패 시 로그아웃 처리
                AuthManager.shared.logout()
                success = false
            }

            // 완료 처리
            self.isRefreshing = false
            completion(success)

            // 대기 중인 요청들도 처리
            self.pendingCompletions.forEach { $0(success) }
            self.pendingCompletions.removeAll()
        }
    }
}
