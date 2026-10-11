//
//  LaunchScreenUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

protocol LaunchUseCaseProtocol {
    func checkAuthAndGetUser() async -> User?
    func checkCurrentVersion() async throws -> VersionEntity.UpdateType
    func getLaunchCameraOnStart() -> Bool
    
    // 권장업데이트 '나중에' 누른 시점, 앱버전 저장
    func saveRecommendedUpdateDismissal()
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
    func checkCurrentVersion() async throws -> VersionEntity.UpdateType {
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        print(">>>>> currentVersion \(currentVersion)")
        let entity = try await repository.checkCurrentVersion(version: currentVersion)
        
        Logger.debug("서버 업데이트 응답: \(entity.updateType)")
        
        switch entity.updateType {
        case .required:
            return .required
        
        case .optional:
            // 지난번에 나중에 버튼을 눌렀는지 확인하고, 일주일이 지난 경우 노출
            if isShowOptionalUpdatePopup(currentVersion: currentVersion) {
                return .optional
            }
            return .none
        
        case .none:
            return .none
        }
    }

    func getLaunchCameraOnStart() -> Bool {
        return repository.getLaunchCameraOnStart()
    }
    
    // 권장 업데이트를 띄울지 말지 여부 확인
    private func isShowOptionalUpdatePopup(currentVersion: String) -> Bool {
        Logger.debug("권장 업데이트를 띄울지 말지 여부 확인")
        
        // 이전 권장업데이트를 연기한 시점, 앱 버전 가져오기
        guard let entity = repository.getRecommendedUpdate() else {
            // 저장된 기록이 없다면, 처음으로 띄우는 것이니까 팝업을 노출한다.
            Logger.debug("저장된 기록이 없다면, 처음으로 띄우는 것이니까 팝업을 노출한다.")
            return true
        }
        
        // 1. 현재 버전과 동일한지 먼저 확인
        guard currentVersion == entity.appVersion else {
            // 동일하지 않은 경우, 권장 업데이트 팝업을 노출하기
            Logger.debug("현재 버전과 동일한지 먼저 확인 - 동일하지 않은 경우, 권장 업데이트 팝업을 노출하기")
            return true
        }
        
        // 2. 지난번에 연기한 시점으로부터 일주일이 지났는지 확인한다. 7일이 지난 경우 팝업 노출
        let isOneWeekPassed = Calendar.current.date(
            byAdding: .day,
            value: 7,
            to: entity.dismissedAt
        ).map { $0 <= Date() } ?? false
        Logger.debug("지난번에 연기한 시점으로부터 일주일이 지났는지 확인한다. 7일이 지난 경우 팝업 노출 \(isOneWeekPassed)")
        return isOneWeekPassed
    }
    
    
    // 권장업데이트 '나중에' 누른 시점, 앱버전 저장
    func saveRecommendedUpdateDismissal() {
        repository.saveRecommendedUpdateDismissal()
    }
    
}
