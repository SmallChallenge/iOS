//
//  PresignedURLDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

struct PresignedURLDto: Codable {
    let uploadURL: String
    let objectKey: String
    let expiresAt: String
    let generatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case uploadURL = "uploadUrl"
        case objectKey, expiresAt, generatedAt
    }
}


