//
//  LogEditorUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//

import Foundation

protocol LogEditorUseCaseProtocol {
    /// 서버 로그 수정
    func editLogForServer(logId: Int, category: Category, visibility: VisibilityType) async throws -> EditLog

    /// 로컬 로그 수정
    func editLogForLocal(logId: UUID, category: Category, visibility: VisibilityType) throws
}
