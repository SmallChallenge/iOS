//
//  TermsRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import Foundation

protocol TermsRepositoryProtocol {
    
    func activeAccount(
        accessToken token: String, 
        agreedToPrivacyPolicy: Bool,
        agreedToTermsOfService: Bool,
        agreedToMarketing: Bool
    ) async throws -> ActiveAccount
    
}
