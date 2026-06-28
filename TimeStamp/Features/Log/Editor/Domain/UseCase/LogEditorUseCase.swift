//
//  LogEditorUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//

import Foundation

final class LogEditorUseCase: LogEditorUseCaseProtocol {
    private let repository: LogEditorRepositoryProtocol

    init(repository: LogEditorRepositoryProtocol) {
        self.repository = repository
    }

    func editLogForServer(logId: Int, category: Category, visibility: VisibilityType) async throws -> EditLog {
        return try await repository.editForServer(
            logId: logId,
            newCategory: category.rawValue,
            newVisibility: visibility.rawValue
        )
    }

    func editLogForLocal(logId: UUID, category: Category, visibility: VisibilityType) throws {
        try repository.editForLocal(
            logId: logId,
            newCategory: category.rawValue,
            newVisibility: visibility.rawValue
        )
    }
}
