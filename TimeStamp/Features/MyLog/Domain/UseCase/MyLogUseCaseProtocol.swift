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
    /// - Returns: (TimeStampLog Entity 배열, PageInfo Entity) (실패 시 빈 배열과 nil)
    func fetchAllLogs(isLoggedIn: Bool) async -> (logs: [TimeStampLog], pageInfo: PageInfo?)

    /// 서버 로그 가져오기 (페이지네이션)
    /// - Parameter page: 가져올 페이지 번호 (0부터 시작)
    /// - Returns: (TimeStampLog Entity 배열, PageInfo Entity) (실패 시 빈 배열과 nil)
    func fetchServerLogs(page: Int) async -> (logs: [TimeStampLog], pageInfo: PageInfo?)
}
