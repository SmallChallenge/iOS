//
//  likeDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//


struct likeDto: Codable {
    let isLiked: Bool
    enum CodingKeys: String, CodingKey {
        case isLiked = "liked"
    }
}
