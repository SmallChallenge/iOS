//
//  NicknameSettingRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation

struct NicknameSettingRepository: NicknameSettingRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    func setNickname(nickName: String) async -> Result<NicknameEntity, NetworkError> {
        let result = await authApiClient.setNickname(nickname: nickName)
        switch result {
        case let .success(dto):
            let entity = dto.toEntity()
            return .success(entity)

        case let .failure(error):
            return .failure(error)
        }
    }
}

