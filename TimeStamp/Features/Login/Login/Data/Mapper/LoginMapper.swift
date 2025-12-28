//
//  LoginMapper.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation

struct LoginMapper {
    static func toEntity(from dto: LoginResponseDto) -> LoginEntity? {
        guard let socialType = LoginType(socialType: dto.socialType) else {
            return nil
        }

        return LoginEntity(
            userId: dto.userId,
            nickname: dto.nickname,
            socialType: socialType,
            profileImageUrl: dto.profileImageUrl,
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken,
            isNewUser: dto.isNewUser,
            needNickname: dto.needNickname
        )
    }
}
