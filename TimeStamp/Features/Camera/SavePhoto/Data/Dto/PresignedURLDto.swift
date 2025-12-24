//
//  PresignedURLDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

struct PresignedURLDto: Codable {
    let presignedUrl: String
    let objectKey: String
    let expiresIn: Int
}
