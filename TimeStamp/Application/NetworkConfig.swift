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
            "https://api.stampy.kr"
        case .prod:
            "https://api.stampy.kr/"
        }
    }
}

/*
 이렇게 init으로 받는게 맞을지? 고민
 
public struct NetworkConfig {
    public let environment: NetworkEnvironment
    public init(environment: NetworkEnvironment) {
        self.environment = environment
    }
    
    public var baseURL: URL {
        switch environment {
        case .dev:
            // TODO: Replace with your actual dev server URL
            return URL(string: "https://dev.example.com")!
        case .prod:
            // TODO: Replace with your actual prod server URL
            return URL(string: "https://api.example.com")!
        }
    }
}
*/
