//
//  SetNicknameDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//


public struct SetNicknameDto: Codable {
    let userId: Int
    let nickname: String
    let isProfileComplete: Bool
}



