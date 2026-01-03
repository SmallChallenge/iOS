//
//  LogoutRepository.swift
//  TimeStamp
//
//  Created by Claude on 1/3/26.
//

import Foundation

protocol LogoutRepositoryProtocol {
    func logout() async throws -> Void
}

struct LogoutRepository: LogoutRepositoryProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    func logout() async throws -> Void {
        let result = await authApiClient.logout()
        switch result {
        case .success:
            return
        case let .failure(error):
            throw error
        }
    }
}
