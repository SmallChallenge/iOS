//
//  MyLogUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

struct MyLogUseCase: MyLogUseCaseProtocol {

    // MARK: - Properties

    private let repository: MyLogRepositoryProtocol

    // MARK: - Init

    init(repository: MyLogRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Methods

    /// 모든 타임스탬프 로그를 조회
    func fetchAllLogs() throws -> [TimeStampLog] {
        return try repository.fetchAllLogs()
    }
}
