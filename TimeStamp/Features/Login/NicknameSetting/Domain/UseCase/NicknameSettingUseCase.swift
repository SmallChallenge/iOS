//
//  NicknameSettingUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation

protocol NicknameSettingUseCaseProtocol {
    func setNickname(nickname: String) async throws -> NicknameEntity
}

final class NicknameSettingUseCase: NicknameSettingUseCaseProtocol {
    private let repository: NicknameSettingRepositoryProtocol
    
    // MARK: - Init
    
    init(repository: NicknameSettingRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: - Methods
    
    func setNickname(nickname: String) async throws -> NicknameEntity {
        let result = await repository.setNickname(nickName: nickname)
        switch result {
        case let .success(entity):
            return entity
        case let .failure(error):
            throw error
        }
    }
}
