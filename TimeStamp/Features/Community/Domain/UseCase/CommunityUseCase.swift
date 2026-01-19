//
//  CommunityUseCase.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

protocol CommunityUseCaseProtocol {
    /// 커뮤니티 피드 조회
    func feeds(category: String?, lastPublishedAt: String?, lastImageId: Int?) async throws -> CommunityListInfo

    /// 신고하기
    func report(imageId: Int) async throws

    /// 신고 취소하기
    func cancelReport(imageId: Int) async throws
    
    /// 차단하기
    func block(nickname: String) async throws

    /// 좋아요
    func like(imageId: Int) async throws
}

struct CommunityUseCase: CommunityUseCaseProtocol {

    private let repository: CommunityRepositoryProtocol

    init(repository: CommunityRepositoryProtocol) {
        self.repository = repository
    }

    func feeds(
        category: String?,
        lastPublishedAt: String?,
        lastImageId: Int?
    ) async throws -> CommunityListInfo {
        try await repository.feeds(
            category: category,
            lastPublishedAt: lastPublishedAt,
            lastImageId: lastImageId,
            size: nil,
            sort: nil
        )
    }

    func report(imageId: Int) async throws {
        try await repository.report(imageId: imageId)
    }

    func cancelReport(imageId: Int) async throws {
        try await repository.cancelReport(imageId: imageId)
    }
    
    func block(nickname: String) async throws {
        try await repository.block(nickname: nickname)
    }

    func like(imageId: Int) async throws {
        try await repository.like(imageId: imageId)
    }
}
