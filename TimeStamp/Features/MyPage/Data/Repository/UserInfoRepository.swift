//
//  UserInfoRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

protocol UserInfoRepositoryProtocol {
    func withdrawal() async throws -> Void
}

struct UserInfoRepository: UserInfoRepositoryProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    func withdrawal() async throws -> Void {
        let result = await authApiClient.withdrawal()
        switch result {
        case .success:
            return
        case let .failure(error):
            throw error
        }
    }
}
