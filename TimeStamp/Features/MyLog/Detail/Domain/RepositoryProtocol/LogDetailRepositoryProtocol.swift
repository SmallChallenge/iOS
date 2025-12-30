//
//  LogDetailRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import UIKit

protocol LogDetailRepositoryProtocol {
    func deleteLogFromServer(logId: Int) async throws
    func deleteLogFromLocal(logId: UUID) async throws

    // 이미지 준비
    func downloadRemoteImage(url: String) async throws -> UIImage
    func loadLocalImage(fileName: String) throws -> UIImage
}
