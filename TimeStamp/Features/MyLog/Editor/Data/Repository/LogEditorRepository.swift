//
//  LogEditorRepository.swift
//  Stampic
//
//  Created by 임주희 on 1/2/26.
//

import Foundation
import Alamofire

struct LogEditorRepository: LogEditorRepositoryProtocol {
    private let apiClient: MyLogApiClientProtocol
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    init(apiClient: MyLogApiClientProtocol, localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.apiClient = apiClient
        self.localDataSource = localDataSource
    }

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


