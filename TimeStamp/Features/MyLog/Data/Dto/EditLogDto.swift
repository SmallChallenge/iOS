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
    let publishedAt: String?
}

extension EditLogDto {
    func toEntity() -> EditLog {
        let category = Category(rawValue: self.category) ?? .etc
        let visibility = VisibilityType(rawValue: self.visibility) ?? .privateVisible
        return EditLog(
            imageId: self.imageId,
            category: category,
            visibility: visibility,
            visibilityChanged: self.visibilityChanged,
            updatedAt: self.updatedAt.toDate(.iso8601) ?? Date(),
            publishedAt: self.publishedAt?.toDate(.iso8601) ?? Date()
        )
    }
}
