//
//  NetworkConfig.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//

import Foundation

public enum NetworkConfig {
    
    public static var environment: NetworkEnvironment {
        #if DEBUG
        return .dev
        #else
        return .prod
        #endif
    }

    public static var baseURL: String {
        switch environment {
        case .dev:
            "https://dev-api.stampy.kr"
        case .prod:
            "https://api.stampy.kr"
        }
    }
}

/*

public enum NetworkEnvironment {
    case dev
    case prod

    public var baseURL: String {
        switch self {
        case .dev:
            return "https://dev-api.stampy.kr"
        case .prod:
            return "https://api.stampy.kr"
        }
    }
}
public struct NetworkConfig {
    public let environment: NetworkEnvironment

    public init(environment: NetworkEnvironment) {
        self.environment = environment
    }
}
 */

/*
container에서 이걸 쓰기
let config = NetworkConfig(
    environment: .prod
)

let networkClient = NetworkClient(
    config: config
)
 
 아니면 아래처럼
 
 #if DEBUG
 let config = NetworkConfig(environment: .dev)
 #else
 let config = NetworkConfig(environment: .prod)
 #endif

 let networkClient = NetworkClient(config: config)

*/

