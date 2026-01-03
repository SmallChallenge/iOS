//
//  CommunityRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

protocol CommunityRepositoryProtocol {
    /// 커뮤니티 피드 조회
    func feeds(category: String?,lastPublishedAt: String?, lastImageId: Int?, size: Int?,  sort: String?) async throws -> CommunityListInfo

    /// 신고하기
    func report(imageId: Int) async throws

    /// 신고 취소하기
    func cancelReport(imageId: Int) async throws

    /// 좋아요
    func like(imageId: Int) async throws
}
