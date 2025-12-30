//
//  LogDetailRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation

final class LogDetailRepository: LogDetailRepositoryProtocol {
    private let apiClient: LogDetailApiClientProtocol
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    init(apiClient: LogDetailApiClientProtocol, localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
    }

    func deleteLogFromServer(logId: Int) async throws {
        let result = await apiClient.deleteLog(logId: logId)

        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
    
    func deleteLogFromLocal(logId: UUID) async throws {
        try localDataSource.delete(id: logId)
    }
}
