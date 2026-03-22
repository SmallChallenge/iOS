//
//  UserInfoDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

public struct UserInfoDto: Codable {
    let userId: Int
    let nickname, socialType: String
    let email: String?
    let profileImageURL: String?
    let isProfileComplete: Bool
    let userStatus, createdAt: String

    enum CodingKeys: String, CodingKey {
        case userId = "userId"
        case nickname, email, socialType
        case profileImageURL = "profileImageUrl"
        case isProfileComplete, userStatus, createdAt
    }

    func toEntity() -> User {
        let loginType = LoginType(rawValue: socialType) ?? .kakao
        return User(
            userId: userId,
            nickname: nickname,
            socialType: loginType,
            profileImageUrl: profileImageURL
        )
    }
}
