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
    
    
}
