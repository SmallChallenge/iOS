//
//  LogoutUseCase.swift
//  TimeStamp
//
//  Created by Claude on 1/3/26.
//

import Foundation

protocol LogoutUseCaseProtocol {
    func logout() async throws
}

class LogoutUseCase: LogoutUseCaseProtocol {
    private let repository: LogoutRepositoryProtocol

    init(repository: LogoutRepositoryProtocol) {
        self.repository = repository
    }

    func logout() async throws {
        try await repository.logout()
    }
}
