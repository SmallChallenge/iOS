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
        // Example: add default headers or token
        // request.setValue("application/json", forHTTPHeaderField: "Accept")
        completion(.success(request))
    }

    // Retry policy (e.g., token refresh, transient errors)
    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        // Simple example: do not retry by default
        completion(.doNotRetry)
    }
}
