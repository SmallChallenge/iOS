//
//  FeedViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

struct FeedViewData {
    let imageId: Int
    let accessURL: String
    let nickname: String
    let profileImageURL: String?
    let isLiked: Bool
    let likeCount: Int
}

// MARK: - Feed Entity to ViewData

extension Feed {
    func toViewData() -> FeedViewData {
        FeedViewData(
            imageId: imageId,
            accessURL: accessURL,
            nickname: nickname,
            profileImageURL: profileImageURL,
            isLiked: isLiked,
            likeCount: likeCount
        )
    }
}
