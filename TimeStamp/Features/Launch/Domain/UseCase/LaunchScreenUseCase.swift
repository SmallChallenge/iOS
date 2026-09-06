//
//  LaunchScreenUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

protocol LaunchUseCaseProtocol {
    func checkAuthAndGetUser() async -> User?
    func checkCurrentVersion() async throws -> VersionEntity
    func getLaunchCameraOnStart() -> Bool
}

class LaunchScreenUseCase: LaunchUseCaseProtocol {
    private let repository: LaunchRepositoryProtocol

    init(repository: LaunchRepositoryProtocol) {
        self.repository = repository
    }

    /// 토큰 갱신 및 유저 정보 가져오기
    func checkAuthAndGetUser() async -> User? {
        guard let refreshToken = AuthManager.shared.getRefreshToken() else {
            Logger.warning("저장된 Refresh Token 없음 → 로그인 필요")
            return nil
        }

        let result = await repository.refreshToken(token: refreshToken)

        switch result {
        case .success(let entity):
            AuthManager.shared.refreshToken(
                accessToken: entity.accessToken,
                refreshToken: entity.refreshToken
            )

            do {
                let user = try await repository.getUserInfo()
                return user
            } catch {
                Logger.error("유저 정보 갱신 실패: \(error)")
                return nil
            }

        case .failure(let error):
            Logger.error("토큰 갱신 실패: \(error)")
            return nil
        }
    }

    /// 버전 확인
    func checkCurrentVersion() async throws -> VersionEntity {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        return try await repository.checkCurrentVersion(version: currentVersion)
    }

    func getLaunchCameraOnStart() -> Bool {
        return repository.getLaunchCameraOnStart()
    }
}
