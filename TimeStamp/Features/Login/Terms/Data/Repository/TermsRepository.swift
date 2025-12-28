//
//  TermsRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import Foundation

struct TermsRepository: TermsRepositoryProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    func activeAccount(accessToken token: String, agreedToPrivacyPolicy: Bool, agreedToTermsOfService: Bool, agreedToMarketing: Bool) async throws -> ActiveAccount {
        let result = await authApiClient.activeAccount(accessToken: token, agreedToPrivacyPolicy: agreedToPrivacyPolicy, agreedToTermsOfService: agreedToTermsOfService, agreedToMarketing: agreedToMarketing)
        switch result {
        case let .success(dto):
            return dto.toEntity()
        case let .failure(error):
            throw error
        }
    }
}
