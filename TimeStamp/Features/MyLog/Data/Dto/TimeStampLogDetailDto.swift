//
//  TimeStampLogDetailDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//

import Foundation

// 서버로그
struct TimeStampLogDetailDto: Codable {
    let id: Int
    let originalFilename: String
    let accessURL: String
    let fileSize: Int
    let contentType, category, visibility, createdAt: String
    let updatedAt: String
    let isOwner: Bool

    enum CodingKeys: String, CodingKey {
        case id = "imageId"
        case originalFilename
        case accessURL = "accessUrl"
        case fileSize, contentType, category, visibility, createdAt, updatedAt
        case isOwner = "owner"
    }
}

extension TimeStampLogDetailDto {
    func toEntity() -> TimeStampLog {
        let categoryEntity = Category(rawValue: self.category) ?? .etc
        let visibilityEntity = VisibilityType(rawValue: self.visibility) ?? .privateVisible

        return TimeStampLog(
            id: UUID(),
            category: categoryEntity,
            timeStamp: self.createdAt.toDate(.iso8601) ?? Date(),
            imageSource: .remote(TimeStampLog.RemoteTimeStampImage(
                id: self.id,
                imageUrl: self.accessURL
            )),
            visibility: visibilityEntity
        )
    }
}
