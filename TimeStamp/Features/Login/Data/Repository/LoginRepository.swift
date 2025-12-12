//
//  LoginRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//


struct LoginRepository: LoginRepositoryProtocol {
    
    private let authApiClient: AuthApiClientProtocol
    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    func kakaoLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await authApiClient.kakaoLogin(accessToken: token)
    }
    
    func appleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await authApiClient.appleLogin(accessToken: token)
    }
    
    func googleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await authApiClient.googleLogin(accessToken: token)
    }
}
