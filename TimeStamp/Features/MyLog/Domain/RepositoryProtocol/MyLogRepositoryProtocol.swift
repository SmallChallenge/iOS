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
    /// 모든 타임스탬프 로그를 조회
    /// - Returns: TimeStampLog Entity 배열
    /// - Throws: 조회 실패 시 에러
    func fetchAllLogs() throws -> [TimeStampLog]

    /// 특정 ID의 타임스탬프 로그를 조회
    /// - Parameter id: 조회할 로그 ID
    /// - Returns: TimeStampLog Entity, 없으면 nil
    /// - Throws: 조회 실패 시 에러
    func fetchLog(by id: UUID) throws -> TimeStampLog?

    // TODO: 추가 기능 (삭제, 수정 등)
}
