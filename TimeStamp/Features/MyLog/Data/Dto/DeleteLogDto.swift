//
//  DeleteLogDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//


struct DeleteLogDto: Codable {
    let imageId: Int
    let originalFilename: String
    let storageDeleteRequested: Bool
    let deletedAt: String
}