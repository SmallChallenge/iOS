//
//  LogDetailRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import UIKit

protocol LogDetailRepositoryProtocol {

    // 상세정보 가져오기
    func fetchLogDetailFromServer(logId: Int) async throws -> TimeStampLog
    func fetchLogFromLocal(logId: UUID) throws -> TimeStampLog


    // 삭제
    func deleteLogFromServer(logId: Int) async throws
    func deleteLogFromLocal(logId: UUID) async throws

    // 이미지 준비
    func downloadRemoteImage(url: String) async throws -> UIImage
    func loadLocalImage(fileName: String) throws -> UIImage
}
