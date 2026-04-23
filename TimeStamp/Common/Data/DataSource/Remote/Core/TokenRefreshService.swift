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

    static let shared = TokenRefreshService()

    private let authApiClient: AuthApiClientProtocol
    private var isRefreshing = false
    private var pendingCompletions: [(Bool) -> Void] = []

    private init() {
        // 토큰 갱신 전용 서비스 (순환 의존성 방지를 위해 interceptor 없는 별도 session 사용)
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20
        let refreshSession = Session(configuration: configuration)
        let authApiClient = AuthApiClient(session: refreshSession)
        self.authApiClient = authApiClient
    }

    /// 토큰 갱신 시도 (최대 3번까지 재시도)
    /// - Parameter completion: 성공(true) 또는 실패(false) 반환
    func refreshToken(completion: @escaping (Bool) -> Void) {
        // 이미 갱신 중이면 대기열에 추가
        if isRefreshing {
            Logger.debug("이미 갱신 중이면 대기열에 추가")
            pendingCompletions.append(completion)
            return
        }

        // refreshToken 확인
        guard let refreshToken = AuthManager.shared.getRefreshToken() else {
            Logger.error("refreshToken 가져오기 실패")
            completion(false)
            return
        }

        isRefreshing = true
        performTokenRefresh(retryCount: 0, refreshToken: refreshToken, completion: completion)
    }

    /// 토큰 갱신을 재시도 로직과 함께 수행
    private func performTokenRefresh(
        retryCount: Int,
        refreshToken: String,
        completion: @escaping (Bool) -> Void
    ) {
        let maxRetries = 3

        Task { [weak self] in
            guard let self = self else {
                completion(false)
                return
            }

            let result = await authApiClient.refreshToken(refreshToken: refreshToken)

            switch result {
            case .success(let dto):
                Logger.success("토큰 갱신 성공")
                // 성공 - 토큰 저장
                AuthManager.shared.refreshToken(
                    accessToken: dto.accessToken,
                    refreshToken: dto.refreshToken
                )

                // 완료 처리
                self.isRefreshing = false
                completion(true)

                // 대기 중인 요청들도 처리
                self.pendingCompletions.forEach { $0(true) }
                self.pendingCompletions.removeAll()

            case .failure(let error):
                // 실패 - 재시도 여부 판단
                let nextRetryCount = retryCount + 1

                if nextRetryCount < maxRetries {
                    Logger.info("토큰 갱신 재시도 \(nextRetryCount)/\(maxRetries): \(error)")
                    // 재시도
                    self.performTokenRefresh(
                        retryCount: nextRetryCount,
                        refreshToken: refreshToken,
                        completion: completion
                    )
                } else {
                    // 최대 재시도 초과 - 로그아웃
                    Logger.error("토큰 갱신 최종 실패, 로그아웃 처리 (\(maxRetries)회 재시도 후): \(error)")
                    AuthManager.shared.logout()

                    // 완료 처리
                    self.isRefreshing = false
                    completion(false)

                    // 대기 중인 요청들도 처리
                    self.pendingCompletions.forEach { $0(false) }
                    self.pendingCompletions.removeAll()
                }
            }
        }
    }
}
