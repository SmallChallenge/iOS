//
//  LogDetailUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation

final class LogDetailUseCase: LogDetailUseCaseProtocol {
    private let repository: LogDetailRepositoryProtocol

    init(repository: LogDetailRepositoryProtocol) {
        self.repository = repository
    }

    func deleteLogFromServer(logId: Int) async throws {
        try await repository.deleteLogFromServer(logId: logId)
    }
}
