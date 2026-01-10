//
//  CommunityListItem.swift
//  TimeStamp
//
//  Created by 임주희 on 1/10/26.
//

import Foundation

enum CommunityListItem: Identifiable {
    case feed(FeedViewData)
    case banner(BannerViewData)
    
    var id: String {
        switch self {
        case let .feed(feed):
            return "feed\(feed.imageId)"
        case let .banner(banner):
            return "banner\(banner.id)"
        }
    }
}
