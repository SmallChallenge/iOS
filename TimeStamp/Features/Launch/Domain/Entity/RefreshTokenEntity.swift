//
//  RefreshTokenEntity.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

struct RefreshTokenEntity {
    let accessToken: String
    let refreshToken: String
}

// Mapper
extension RefreshDto {
    func toEntity() -> RefreshTokenEntity {
        RefreshTokenEntity(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}
