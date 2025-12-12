//
//  LoginResponseDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

/// 소셜 로그인
public struct LoginResponseDto: Codable {
    let userID: Int
    let nickname, socialType: String
    let profileImageURL: String
    let accessToken, refreshToken: String
    let isNewUser, needNickname: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case nickname, socialType
        case profileImageURL = "profileImageUrl"
        case accessToken, refreshToken, isNewUser, needNickname
    }
}

