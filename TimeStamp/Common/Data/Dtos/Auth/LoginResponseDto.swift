//
//  LoginResponseDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

/// 소셜 로그인
public struct LoginResponseDto: Codable {
    let userId: Int
    let nickname: String?
    let socialType: String
    let profileImageUrl: String?
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
    let userStatus: String
    let needNickname: Bool
}


