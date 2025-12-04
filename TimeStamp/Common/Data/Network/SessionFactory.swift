//
//  SessionFactory.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation
import Alamofire


public struct SessionFactory {
    public static func makeSession(for env: NetworkEnvironment) -> Session {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 20
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
