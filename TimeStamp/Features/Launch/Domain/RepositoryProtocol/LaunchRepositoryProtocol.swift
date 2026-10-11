//
//  LaunchRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

protocol LaunchRepositoryProtocol {
    func refreshToken(token: String) async -> Result<RefreshTokenEntity, NetworkError>
    func getUserInfo() async throws -> User
    
    /// 앱 실행시 카메라 실행여부 가져오기 (기본값: false)
    func getLaunchCameraOnStart() -> Bool
    
    /// 버전 확인
    func checkCurrentVersion(version: String) async throws -> VersionEntity
    
    /// 권장업데이트를 연기한 시점, 앱 버전을 저장
    func saveRecommendedUpdateDismissal()
    
    /// 권장 업데이트를 연기한 시점, 앱 버전 가져오기
    func getRecommendedUpdate() -> RecommendedUpdateDismissalEntity?
}
