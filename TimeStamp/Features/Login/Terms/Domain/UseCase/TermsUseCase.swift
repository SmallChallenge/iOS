//
//  TermsUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import Foundation

protocol TermsUseCaseProtocol {
    func activeAccount(
        accessToken token: String,
        agreedToPrivacyPolicy: Bool,
        agreedToTermsOfService: Bool,
        agreedToMarketing: Bool
    ) async throws -> ActiveAccount
}

final class TermsUseCase: TermsUseCaseProtocol {
    private let repository: TermsRepositoryProtocol
    
    init(repository: TermsRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func activeAccount(accessToken token: String, agreedToPrivacyPolicy: Bool, agreedToTermsOfService: Bool, agreedToMarketing: Bool) async throws -> ActiveAccount {
        try await repository.activeAccount(
            accessToken: token,
            agreedToPrivacyPolicy: agreedToPrivacyPolicy,
            agreedToTermsOfService: agreedToTermsOfService,
            agreedToMarketing: agreedToMarketing
        )
    }
}
