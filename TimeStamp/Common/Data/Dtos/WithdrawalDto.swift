//
//  WithdrawalDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

public struct WithdrawalDto: Codable {
    let userId: Int
    let success: Bool
    let maskedNickname, socialType: String
    let invalidatedTokenCount: Int
    let withdrawalTime: String
    
    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case success, maskedNickname, socialType, invalidatedTokenCount, withdrawalTime
    }
}
