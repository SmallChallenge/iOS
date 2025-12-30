//
//  LogDetailRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import UIKit

final class LogDetailRepository: LogDetailRepositoryProtocol {
    private let apiClient: LogDetailApiClientProtocol
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    init(apiClient: LogDetailApiClientProtocol, localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
    }

    func deleteLogFromServer(logId: Int) async throws {
        let result = await apiClient.deleteLog(logId: logId)

        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
    
    func deleteLogFromLocal(logId: UUID) async throws {
        try localDataSource.delete(id: logId)
    }

    // MARK: - 이미지 준비

    func downloadRemoteImage(url: String) async throws -> UIImage {
        guard let imageUrl = URL(string: url) else {
            throw NSError(domain: "InvalidURL", code: -1, userInfo: nil)
        }

        let (data, _) = try await URLSession.shared.data(from: imageUrl)

        guard let image = UIImage(data: data) else {
            throw NSError(domain: "ImageConversionFailed", code: -1, userInfo: nil)
        }

        return image
    }

    func loadLocalImage(fileName: String) throws -> UIImage {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let imagePath = documentsPath.appendingPathComponent(fileName)

        guard let imageData = try? Data(contentsOf: imagePath),
              let image = UIImage(data: imageData) else {
            throw NSError(domain: "LocalImageLoadFailed", code: -1, userInfo: nil)
        }

        return image
    }
}
