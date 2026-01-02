//
//  LogDetailUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import UIKit

protocol LogDetailUseCaseProtocol {
    // 상세정보 가져오기
    func fetchLogDetailFromServer(logId: Int) async throws -> TimeStampLog
    func fetchLogFromLocal(logId: UUID) throws -> TimeStampLog

    // 삭제
    func deleteLogFromServer(logId: Int) async throws
    func deleteLogFromLocal(logId: UUID) async throws

    // 이미지 준비
    func prepareImageForSharing(imageSource: TimeStampLog.ImageSource) async throws -> UIImage
}
