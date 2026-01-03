//
//  CommunityRepository.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

struct CommunityRepository: CommunityRepositoryProtocol {

    private let apiClient: CommunityApiClientProtocol

    init(apiClient: CommunityApiClientProtocol) {
        self.apiClient = apiClient
    }

    func feeds(category: String?, lastPublishedAt: String?, lastImageId: Int?, size: Int?, sort: String?) async throws -> CommunityListInfo {
        let result = await apiClient.feeds(category: category, size: size, lastPublishedAt: lastPublishedAt, lastImageId: lastImageId, sort: sort)
        switch result {
        case .success(let dto):
            return dto.toEntity()
        case .failure(let error):
            throw error
        }
    }

    func report(imageId: Int) async throws {
        let result = await apiClient.report(imageId: imageId)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

    func cancelReport(imageId: Int) async throws {
        let result = await apiClient.cancelReport(imageId: imageId)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

    func like(imageId: Int) async throws {
        let result = await apiClient.like(imageId: imageId)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}



