//
//  MyLogRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

/// MyLog Repository Protocol (Domain Layer)
/// - Entity 기반 인터페이스
/// - Data Layer에서 구현
protocol MyLogRepositoryProtocol {
    /// 모든 타임스탬프 로그를 조회 (from local)
    /// - Returns: TimeStampLog Entity 배열
    /// - Throws: 조회 실패 시 에러
    func fetchAllLogsFromLocal() throws -> [TimeStampLog]
    
    /// 카테고리 별로 로컬 타임스탬프를 조회
    /// - Parameter category: category
    /// - Returns: TimeStampLog Entity 배열
    func fetchLogsFromLocal(by category: String) throws -> [TimeStampLog]

    /// 로컬 타임스탬프 로그의 개수를 조회
    /// - Returns: 로컬에 저장된 로그의 개수
    /// - Throws: 조회 실패 시 에러
    func fetchLocalLogsCount() throws -> Int

    /// 모든 타임스탬프 로그를 조회 (from server)
    /// - Parameter category: 카테고리, 안보내면 전체
    /// - Parameter page: 0부터 시작
    /// - Returns: (TimeStampLog Entity 배열, PageInfo Entity)
    /// - Throws: 조회 실패 시 에러
    func fetchAllLogFromServer(category: String?, page: Int) async throws -> (logs: [TimeStampLog], hasNext: Bool)

    // TODO: 추가 기능 (삭제, 수정 등)
}
