//
//  LoginRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation

protocol LoginRepositoryProtocol {
    func kakaoLogin(accessToken token: String) async -> Result<LoginEntity, NetworkError>
    func appleLogin(accessToken token: String) async -> Result<LoginEntity, NetworkError>
    func googleLogin(accessToken token: String) async -> Result<LoginEntity, NetworkError>
}


