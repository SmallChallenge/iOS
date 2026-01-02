//
//  CommunityListInfo.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

struct CommunityListInfo {
    let feeds: [Feed]
    let sliceInfo: SliceInfo

    struct SliceInfo {
        let nextCursorId: Int
        let nextCursorPublishedAt: String
        let hasNext: Bool
        let size: Int
    }
}

struct Feed {
    let imageId: Int
    let accessURL: String
    let nickname: String
    let profileImageURL: String?
    let isLiked: Bool
    let likeCount: Int
    let publishedAt: String
}
