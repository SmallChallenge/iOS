//
//  TokenStoring.swift
//  TimeStamp
//
//  Created by 임주희 on 11/24/26.
//


import Foundation


// 토큰을 저장하고 가져오는 역할
protocol TokenStoring: Sendable {
    func getAccessToken() -> String?
    func getRefreshToken() -> String?

    func updateTokens(
        accessToken: String,
        refreshToken: String
    )
}


