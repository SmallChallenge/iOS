//
//  LoginEntity.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation

struct LoginEntity {
    let userId: Int
    let nickname: String?
    let socialType: LoginType
    let profileImageUrl: String?
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
    let status: UserStatus
    let needNickname: Bool
    
    enum UserStatus: String {
        case pending = "PENDING"
        case active = "ACTIVE"
    }
}
