//
//  NicknameDto+Entity.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation

extension SetNicknameDto {
    func toEntity() -> NicknameEntity {
        NicknameEntity(
            userId: self.userId,
            nickname: self.nickname,
            isProfileComplete: self.isProfileComplete
        )
    }
}
