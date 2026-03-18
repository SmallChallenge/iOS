//
//  APIRequestInterceptor.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation
import Alamofire


public final class APIRequestInterceptor: RequestInterceptor {

    
    private let tokenRefreshService: TokenRefreshService

    public init() {
        
        // 토큰 갱신 전용 서비스 (순환 의존성 방지를 위해 interceptor 없는 별도 session 사용)
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20
        let refreshSession = Session(configuration: configuration)
        let authApiClient = AuthApiClient(session: refreshSession)
        self.tokenRefreshService = TokenRefreshService(authApiClient: authApiClient)
    }

    // Adapt request if needed (e.g., attach auth headers)
    public func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest

        // 기본 헤더 추가
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 인증 토큰 있으면 추가
         if let token = AuthManager.shared.getAccessToken() {
             request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
         }

        completion(.success(request))
    }

    // Retry policy (e.g., token refresh, transient errors)
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse else {
            completion(.doNotRetry)
            return
        }

        // 401,403 에러 시 토큰 갱신 후 재시도
        if [401, 403].contains(response.statusCode) {
            tokenRefreshService.refreshToken { success in
                completion(success ? .retry : .doNotRetry)
            }
        } else if (500...599).contains(response.statusCode) {
            // 서버 에러 시 최대 3번까지 재시도
            let retryCount = request.retryCount
            completion(retryCount < 3 ? .retryWithDelay(2.0) : .doNotRetry)
        } else {
            completion(.doNotRetry)
        }
    }
}


