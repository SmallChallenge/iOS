//
//  APIRequestInterceptor.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation
import Alamofire


public final class APIRequestInterceptor: RequestInterceptor {
    private let environment: NetworkEnvironment

    public init(environment: NetworkEnvironment) {
        self.environment = environment
    }

    // Adapt request if needed (e.g., attach auth headers)
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        // 기본 헤더 추가
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 인증 토큰이 필요한 경우 (추후 구현)
        // if let token = TokenManager.shared.accessToken {
        //     request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // }

        completion(.success(request))
    }

    // Retry policy (e.g., token refresh, transient errors)
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }

        // 401 에러 시 토큰 갱신 후 재시도 (추후 구현)
        if response.statusCode == 401 {
            // TODO: 토큰 갱신 로직 구현
            // refreshToken 후 .retry 또는 .retryWithDelay 반환
            completion(.doNotRetry)
        } else if (500...599).contains(response.statusCode) {
            // 서버 에러 시 최대 3번까지 재시도
            let retryCount = request.retryCount
            completion(retryCount < 3 ? .retryWithDelay(2.0) : .doNotRetry)
        } else {
            completion(.doNotRetry)
        }
    }
}
