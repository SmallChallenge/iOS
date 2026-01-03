//
//  WithdrawalUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

protocol WithdrawalUseCaseProtocol {
    func withdrawal() async throws
}

final class WithdrawalUseCase: WithdrawalUseCaseProtocol {
    private let repository: UserInfoRepositoryProtocol

    init(repository: UserInfoRepositoryProtocol) {
        self.repository = repository
    }

    func withdrawal() async throws {
        try await repository.withdrawal()
    }
}
