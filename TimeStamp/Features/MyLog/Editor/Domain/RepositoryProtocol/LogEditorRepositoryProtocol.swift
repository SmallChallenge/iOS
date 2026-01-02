//
//  LogEditorRepositoryProtocol.swift
//  Stampic
//
//  Created by 임주희 on 1/2/26.
//

import Foundation

protocol LogEditorRepositoryProtocol {
    /// 서버 로그 수정
    func editForServer(logId id: Int, newCategory category: String, newVisibility visibility: String) async throws -> EditLog

    /// 로컬 로그 수정
    func editForLocal(logId id: UUID, newCategory category: String, newVisibility visibility: String) throws
}
