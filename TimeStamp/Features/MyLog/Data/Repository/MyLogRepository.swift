//
//  MyLogRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

/// MyLog Repository 구현 (Data Layer)
/// - LocalTimeStampLogDataSource를 사용하여 로컬 데이터 관리
/// - 나중에 RemoteAPI 추가 가능
final class MyLogRepository: MyLogRepositoryProtocol {
    private let pageSize = 20

    // MARK: - Properties

    /// 로컬 저장소 (CoreData)
    private let localDataSource: LocalTimeStampLogDataSourceProtocol
    
    private let apiClient: MyLogApiClientProtocol

    // MARK: - Init

    init(localDataSource: LocalTimeStampLogDataSourceProtocol, apiClient: MyLogApiClientProtocol) {
        self.localDataSource = localDataSource
        self.apiClient = apiClient
    }

    // MARK: - 로컬 로그 가져오기

    /// 모든 타임스탬프 로그를 조회
    func fetchAllLogsFromLocal() throws -> [TimeStampLog] {
        let dtos = try localDataSource.readAll()
        return dtos.map { $0.toEntity() }
    }
    
    // MARK: - 서버 로그 가져오기
    
    func fetchAllLogFromServer(page: Int) async throws -> [TimeStampLog] {
        let result = await apiClient.fetchMyLogList(category: nil, page: page, size: pageSize)
        
        guard case .success(let response) = result else {
            if case .failure(let error) = result {
                Logger.error("사진 목록 가져오기 요청 실패: \(error)")
                throw error
            }
            throw NetworkError.requestFailed("사진 목록 가져오기 요청 실패:")
        }
        
        _ = response.data?.pageInfo
        let myLogs: [MyLogsDto.TimeStampLog] = response.data?.logs ?? []
        return myLogs.map { $0.toEntity() }
    }
}
