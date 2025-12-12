//
//  SessionFactory.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//

import Foundation
import Alamofire

/// SessionFactoryProtocol의 기본 구현체
/// Alamofire Session을 환경에 맞게 생성
public final class SessionFactory {

    public init() {}

    public func makeSession(for env: NetworkEnvironment) -> Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20
        configuration.timeoutIntervalForResource = 30

        // Environment별로 타임아웃 설정 (개발 환경에서는 더 긴 타임아웃)
        //configuration.timeoutIntervalForRequest = env == .dev ? 30 : 20
        //configuration.timeoutIntervalForResource = env == .dev ? 60 : 30

        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        #if DEBUG
        let monitors: [EventMonitor] = [APINetworkLogger()]
        #else
        let monitors: [EventMonitor] = []
        #endif

        let interceptor = APIRequestInterceptor(environment: env)

        return Session(configuration: configuration,
                       interceptor: interceptor,
                       eventMonitors: monitors)
    }
}
