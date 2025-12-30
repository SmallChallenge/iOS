//
//  LogDetailRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation

protocol LogDetailRepositoryProtocol {
    func deleteLogFromServer(logId: Int) async throws
}
