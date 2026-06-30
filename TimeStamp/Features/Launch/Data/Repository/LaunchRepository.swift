//
//  LaunchRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

struct LaunchRepository: LaunchRepositoryProtocol {
    
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    /// 토큰 갱신
    func refreshToken(token: String) async -> Result<RefreshTokenEntity, NetworkError> {
        let result = await authApiClient.refreshToken(refreshToken: token)
        switch result {
        case let .success(dto):
            let entity = dto.toEntity()
            return .success(entity)

        case let .failure(error):
            return .failure(error)
        }
    }

    /// 유저 정보 조회
    func getUserInfo() async throws -> User {
        let result = await authApiClient.userInfo()
        switch result {
        case let .success(dto):
            return dto.toEntity()
        case let .failure(error):
            throw error
        }
    }
    
    /// 앱 실행시 카메라 실행여부 가져오기 (기본값: false)
    func getLaunchCameraOnStart() -> Bool {
        UserSettings.shared.shouldLaunchCameraOnStart
    }
    
    

}
