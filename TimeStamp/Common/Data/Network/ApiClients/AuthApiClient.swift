//
//  LoginRouter.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation
import Alamofire


public enum AuthRouter {
    // 소셜 로그인
    case kakaoLogin(accessToken: String)
    case appleLogin(accessToken: String)
    case googleLogin(accessToken: String)
    
    // 토큰 재발급
    // 로그아웃
    // 회원탈퇴
    // 닉네임 설정
    
}
extension AuthRouter: Router {
   

    public var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    public var path: String {
        "api/v1/auth/social-login"
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public var parameters: Parameters? {
        switch self {
        case let .kakaoLogin(token):
            let params: Parameters = [
                "socialType" : "Kakao",
                "accessToken" : token,
            ]
            return params
           
        case let .appleLogin(token):
            let params: Parameters = [
                "socialType" : "Apple",
                "accessToken" : token,
            ]
            return params
            
        case let .googleLogin(token):
            let params: Parameters = [
                "socialType" : "Google",
                "accessToken" : token,
            ]
            return params
        }
    }
    
    public var headers: HTTPHeaders? {
        nil
    }
    
    public var encoding: Encoding? {
        nil
    }
    
}

// MARK: - API Client Protocol

public protocol AuthApiClientProtocol {
    func kakaoLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    func appleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    func googleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError>
    // 토큰 재발급
    // 로그아웃
    // 회원탈퇴
    // 닉네임 설정
    
}

// MARK: - API Client

public class AuthApiClient: ApiClient<AuthRouter>, AuthApiClientProtocol {
    public func kakaoLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.kakaoLogin(accessToken: token))
    }
    public func appleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.appleLogin(accessToken: token))
    }
    public func googleLogin(accessToken token: String) async -> Result<LoginResponseDto, NetworkError> {
        await request(AuthRouter.googleLogin(accessToken: token))
    }
}
