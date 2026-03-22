//
//  RefreshDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

public struct RefreshDto: Codable {
    let accessToken: String
    let refreshToken: String
}
