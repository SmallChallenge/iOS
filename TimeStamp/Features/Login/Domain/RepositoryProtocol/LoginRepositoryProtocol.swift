//
//  LoginRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation

public protocol LoginRepositoryProtocol {
    func kakaoLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    func appleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    func googleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
}


