//
//  LogDetailRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import UIKit

final class LogDetailRepository: LogDetailRepositoryProtocol {
    private let apiClient: MyLogApiClientProtocol
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    init(apiClient: MyLogApiClientProtocol, localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
    }

    // MARK: - Fetch

    func fetchLogDetailFromServer(logId: Int) async throws -> TimeStampLog {
        let result = await apiClient.fetchLogDetail(id: logId)

        switch result {
        case let .success(dto):
            // TimeStampLogDetail 엔티티 없이 그냥 TimeStampLog를 사용함.
            return dto.toEntity()
        case let .failure(error):
            Logger.error("서버 로그 조회 실패: \(error)")
            throw error
        }
    }

    func fetchLogFromLocal(logId: UUID) throws -> TimeStampLog {
        guard let dto = try localDataSource.read(id: logId) else {
            throw RepositoryError.entityNotFound
        }

        return dto.toEntity()
    }

    // MARK: - Delete

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
    
    
    // MARK: - 로그 수정
    func editForServer(logId id: Int, newCategory category: String, newVisibility visibility: String) async throws -> EditLog {
        let result = await apiClient.editLog(id: id, category: category, visibility: visibility)

        switch result {
        case let .success(dto):
            let entity = dto.toEntity()
            return entity
        case let .failure(error):
            Logger.error("서버 로그 수정 요청 실패: \(error)")
            throw error
        }
    }

    func editForLocal(logId id: UUID, newCategory category: String, newVisibility visibility: String) throws {
        guard var dto = try localDataSource.read(id: id) else {
            throw RepositoryError.entityNotFound
        }

        let updatedDto = LocalTimeStampLogDto(
            id: dto.id,
            category: category,
            timeStamp: dto.timeStamp,
            imageFileName: dto.imageFileName,
            visibility: visibility
        )

        try localDataSource.update(updatedDto)
        Logger.success("로컬 로그 수정 성공")
    }
}
