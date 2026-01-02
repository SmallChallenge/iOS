//
//  LogDetailUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import UIKit

final class LogDetailUseCase: LogDetailUseCaseProtocol {
    private let repository: LogDetailRepositoryProtocol

    init(repository: LogDetailRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Fetch

    func fetchLogDetailFromServer(logId: Int) async throws -> TimeStampLog {
        return try await repository.fetchLogDetailFromServer(logId: logId)
    }

    func fetchLogFromLocal(logId: UUID) throws -> TimeStampLog {
        return try repository.fetchLogFromLocal(logId: logId)
    }

    // MARK: - Delete

    func deleteLogFromServer(logId: Int) async throws {
        try await repository.deleteLogFromServer(logId: logId)
    }
    
    func deleteLogFromLocal(logId: UUID) async throws {
        try await repository.deleteLogFromLocal(logId: logId)
    }

    // MARK: - 이미지 준비

    func prepareImageForSharing(imageSource: TimeStampLog.ImageSource) async throws -> UIImage {
        switch imageSource {
        case let .remote(remoteImage):
            return try await repository.downloadRemoteImage(url: remoteImage.imageUrl)

        case let .local(localImage):
            return try repository.loadLocalImage(fileName: localImage.imageFileName)
        }
    }
}
