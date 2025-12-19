//
//  MyLogUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

protocol MyLogUseCaseProtocol {
    /// 모든 타임스탬프 로그를 조회
    /// - Returns: TimeStampLog Entity 배열
    /// - Throws: 조회 실패 시 에러
    func fetchAllLogs() throws -> [TimeStampLog]
}
