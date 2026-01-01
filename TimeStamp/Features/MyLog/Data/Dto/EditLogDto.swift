//
//  EditLogDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//

import Foundation

struct EditLogDto: Codable {
    let imageId: Int
    let category: String
    let visibility: String
    let visibilityChanged: Bool
    let updatedAt: String
    let publishedAt: String
}
