//
//  SaveTimeStampDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

struct SaveTimeStampDto: Codable {
    let imageId: Int
    let userId: Int
    let originalFilename: String
    let objectKey: String
    let accessURL: String
    let fileSize: Int
    let contentType: String
    let category: String
    let visibility: String
    let savedAt: String

    enum CodingKeys: String, CodingKey {
        case imageId = "imageId"
        case userId = "userId"
        case originalFilename, objectKey
        case accessURL = "accessUrl"
        case fileSize, contentType, category, visibility, savedAt
    }
}

