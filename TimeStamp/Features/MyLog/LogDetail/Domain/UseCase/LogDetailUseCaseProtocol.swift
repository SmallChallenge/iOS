//
//  LogDetailUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import UIKit

protocol LogDetailUseCaseProtocol {
    func deleteLogFromServer(logId: Int) async throws
    func deleteLogFromLocal(logId: UUID) async throws

    // 이미지 준비
    func prepareImageForSharing(imageSource: TimeStampLog.ImageSource) async throws -> UIImage
}
