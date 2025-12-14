//
//  LoginUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation

protocol LoginUseCaseProtocol {
    func kakaoLogin(accessToken: String) async -> Result<LoginResponseDto, NetworkError>
    func appleLogin(accessToken: String) async -> Result<LoginResponseDto, NetworkError>
    func googleLogin(accessToken: String) async -> Result<LoginResponseDto, NetworkError>
}

public struct LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol

    public init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }

    func kakaoLogin(accessToken: String) async -> Result<LoginResponseDto, NetworkError> {
        await repository.kakaoLogin(accessToken: accessToken)
    }

    func appleLogin(accessToken: String) async -> Result<LoginResponseDto, NetworkError> {
        await repository.appleLogin(accessToken: accessToken)
    }

    func googleLogin(accessToken: String) async -> Result<LoginResponseDto, NetworkError> {
        await repository.googleLogin(accessToken: accessToken)
    }
}
