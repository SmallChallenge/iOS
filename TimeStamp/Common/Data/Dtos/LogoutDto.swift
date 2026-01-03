//
//  LogoutDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

public struct LogoutDto: Codable {
    let userID: Int
        let success, allDevices: Bool
        let invalidatedTokenCount: Int
        let logoutTime: String

        enum CodingKeys: String, CodingKey {
            case userID = "userId"
            case success, allDevices, invalidatedTokenCount, logoutTime
        }
}
