//
//  AppDI.swift
//  SmallChallenge
//
//  Created by 임주희 on 11/29/25.
//

import Foundation
import Alamofire

final class AppDI {
    static let shared = AppDI()

    let session: Session
    

    private init() {
        #if DEBUG
        let env: NetworkEnvironment = .dev
        #else
        let env: NetworkEnvironment = .prod
        #endif

        self.session = SessionFactory.makeSession(for: env)
    }
}
