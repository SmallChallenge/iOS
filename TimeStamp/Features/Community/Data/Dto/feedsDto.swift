//
//  feedsDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation


struct feedsDto: Codable {
    let feeds: [FeedDto]
    let sliceInfo: SliceInfoDto
    
    struct SliceInfoDto: Codable {
        let nextCursorID: Int
        let nextCursorPublishedAt: String
        let hasNext: Bool
        let size: Int
        
        enum CodingKeys: String, CodingKey {
            case nextCursorID = "nextCursorId"
            case nextCursorPublishedAt, hasNext, size
        }
    }
}
struct FeedDto: Codable {
    let imageId: Int
    let accessURL: String
    let nickname: String
    let profileImageURL: String?
    let isLiked: Bool
    let likeCount: Int
    let publishedAt: String

    enum CodingKeys: String, CodingKey {
        case imageId = "imageId"
        case accessURL = "accessUrl"
        case nickname
        case profileImageURL = "profileImageUrl"
        case likeCount, publishedAt
        case isLiked = "liked"
    }
}


extension feedsDto {
    func toEntity() -> CommunityListInfo {
        CommunityListInfo(
            feeds: feeds.map { $0.toEntity() },
            sliceInfo: sliceInfo.toEntity()
        )
    }
}

extension feedsDto.SliceInfoDto {
    func toEntity() -> CommunityListInfo.SliceInfo {
        CommunityListInfo.SliceInfo(
            nextCursorId: nextCursorID,
            nextCursorPublishedAt: nextCursorPublishedAt,
            hasNext: hasNext,
            size: size
        )
    }
}

extension FeedDto {
    func toEntity() -> Feed {
        Feed(
            imageId: imageId,
            accessURL: accessURL,
            nickname: nickname,
            profileImageURL: profileImageURL,
            isLiked: isLiked,
            likeCount: likeCount,
            publishedAt: publishedAt
        )
    }
}


