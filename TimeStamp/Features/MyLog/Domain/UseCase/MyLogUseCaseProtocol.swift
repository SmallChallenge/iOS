//
//  MyLogUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

protocol MyLogUseCaseProtocol {
    /// 모든 타임스탬프 로그를 조회
    /// - Parameter isLoggedIn: 로그인 여부 (로그인 시 서버 로그도 가져옴)
    /// - Returns: TimeStampLog Entity 배열 (실패 시 빈 배열)
    func fetchAllLogs(isLoggedIn: Bool) async -> [TimeStampLog]
}
