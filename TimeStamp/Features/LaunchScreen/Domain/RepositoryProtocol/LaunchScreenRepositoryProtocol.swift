//
//  LaunchScreenRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

protocol LaunchScreenRepositoryProtocol {
    func refreshToken(token: String) async -> Result<RefreshTokenEntity, NetworkError>
}
