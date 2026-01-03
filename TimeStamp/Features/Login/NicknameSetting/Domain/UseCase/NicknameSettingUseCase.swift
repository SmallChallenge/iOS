//
//  NicknameSettingUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation

protocol NicknameSettingUseCaseProtocol {
    func setNickname(nickname: String, accessToken: String?) async throws -> NicknameEntity
    func login(entity: LoginEntity)
    func updateUserInfo(nickname: String)
}

final class NicknameSettingUseCase: NicknameSettingUseCaseProtocol {
    private let repository: NicknameSettingRepositoryProtocol
    
    // MARK: - Init
    
    init(repository: NicknameSettingRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Methods
    
    func setNickname(nickname: String, accessToken: String?) async throws -> NicknameEntity {
        let result = await repository.setNickname(nickName: nickname, accessToken: accessToken)
        switch result {
        case let .success(entity):
            return entity
        case let .failure(error):
            throw error
        }
    }
    
    func login(entity: LoginEntity){
        let user = User(
            userId: entity.userId,
            nickname: entity.nickname,
            socialType: entity.socialType,
            profileImageUrl: entity.profileImageUrl
        )
        AuthManager.shared.login(
            user: user,
            accessToken: entity.accessToken,
            refreshToken: entity.refreshToken
        )
    }
    
    func updateUserInfo(nickname: String){
        AuthManager.shared.updateNickname(nickname)
    }
}
