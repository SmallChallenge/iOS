//
//  SessionFactoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation
import Alamofire

/// Session 생성을 위한 Factory 프로토콜
/// DI를 통해 주입받아 사용하며, 테스트 시 Mock 구현 가능
public protocol SessionFactoryProtocol {
    /// 주어진 환경에 맞는 Session 생성
    func makeSession(for environment: NetworkEnvironment) -> Session
}
