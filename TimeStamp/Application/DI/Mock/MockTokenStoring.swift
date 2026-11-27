//
//  MockTokenStoring.swift
//  TimeStamp
//
//  Created by 임주희 on 11/24/26.
//


final class MockTokenStoring: TokenStoring {
    func getAccessToken() -> String? { return nil }
    
    func getRefreshToken() -> String? { return nil }
    
    func updateTokens(accessToken: String, refreshToken: String) {}
}