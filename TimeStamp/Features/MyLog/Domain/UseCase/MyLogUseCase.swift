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
    private var page: Int = 0

    // MARK: - Init

    init(repository: MyLogRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Methods

    /// 모든 타임스탬프 로그를 조회
    func fetchAllLogs() async throws -> [TimeStampLog] {
        
        // 로컬 로그 가져오기
        let localLogs = try repository.fetchAllLogsFromLocal()
        
        
        // TODO: 서버 로그 가져오기
        let serverLogs = try await repository.fetchAllLogFromServer(page: page)
        
        // TODO 합치고, 정렬하기
        
        
        return serverLogs
        
        
    }
}
