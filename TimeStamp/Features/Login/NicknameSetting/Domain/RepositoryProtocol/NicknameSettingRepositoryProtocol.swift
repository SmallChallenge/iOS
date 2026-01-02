//
//  NicknameSettingRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation

protocol NicknameSettingRepositoryProtocol {
    func setNickname(nickName: String, accessToken: String?) async -> Result<NicknameEntity, NetworkError>
}
