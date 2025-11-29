//
//  LoginRepository.swift
//  SmallChallenge
//
//  Created by 임주희 on 11/29/25.
//

import Foundation
import Alamofire


protocol LoginRepositoryProtocol {
    func kakaoLogin()async -> Result<LoginResponseDto, NetworkError>
    func appleLogin()async -> Result<LoginResponseDto, NetworkError>
    func googleLogin() async -> Result<LoginResponseDto, NetworkError>
}

struct LoginRepository: LoginRepositoryProtocol {
    private let loginApiClient: LoginApiClient
    
    init(loginApiClient: LoginApiClient){
        self.loginApiClient = loginApiClient
    }
    
    func appleLogin() async -> Result<LoginResponseDto, NetworkError> {
        await loginApiClient.appleLogin()
    }
    
    func googleLogin() async -> Result<LoginResponseDto, NetworkError> {
        await loginApiClient.googleLogin()
    }
    
    func kakaoLogin() async -> Result<LoginResponseDto, NetworkError> {
        await loginApiClient.kakaoLogin()
    }

}
