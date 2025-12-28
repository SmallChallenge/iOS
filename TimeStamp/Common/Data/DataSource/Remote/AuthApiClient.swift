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
    case refresh(token: String)
    // 로그아웃
    // 회원탈퇴
    
    // 닉네임 중복 확인
    // 닉네임 설정
    case setNickname(nickname: String)
    
}
extension AuthRouter: Router {
   

    public var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .appleLogin, .googleLogin, .kakaoLogin:
            "api/v1/auth/social-login"
            
        case .refresh:
            "api/v1/auth/refresh"
            
        case .setNickname:
            "/api/v1/auth/nickname"
        }
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public var parameters: Parameters? {
        switch self {
        case let .kakaoLogin(token):
            let params: Parameters = [
                "socialType" : "KAKAO",
                "accessToken" : token,
            ]
            return params
           
        case let .appleLogin(token):
            let params: Parameters = [
                "socialType" : "APPLE",
                "accessToken" : token,
            ]
            return params
            
        case let .googleLogin(token):
            let params: Parameters = [
                "socialType" : "GOOGLE",
                "accessToken" : token,
            ]
            return params
            
        case let .refresh(token):
            let params: Parameters = [
                "refreshToken" : token,
            ]
            return params
            
        case let .setNickname(nickname):
            let params: Parameters = [
                "nickname" : nickname,
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
    func kakaoLogin(accessToken token: String) async -> Result<ResponseBody<LoginResponseDto>, NetworkError>
    func appleLogin(accessToken token: String) async -> Result<ResponseBody<LoginResponseDto>, NetworkError>
    func googleLogin(accessToken token: String) async -> Result<ResponseBody<LoginResponseDto>, NetworkError>
    /// 토큰 재발급
    func refreshToken(refreshToken token: String) async -> Result<ResponseBody<RefreshDto>, NetworkError>
    // 로그아웃
    // 회원탈퇴
    
    // 닉네임 중복확인
    // 닉네임 설정
    func setNickname(nickname: String) async -> Result<ResponseBody<SetNicknameDto>, NetworkError>
    
}

// MARK: - API Client

public class AuthApiClient: ApiClient<AuthRouter>, AuthApiClientProtocol {
    public func kakaoLogin(accessToken token: String) async -> Result<ResponseBody<LoginResponseDto>, NetworkError> {
        await request(AuthRouter.kakaoLogin(accessToken: token))
    }
    public func appleLogin(accessToken token: String) async -> Result<ResponseBody<LoginResponseDto>, NetworkError> {
        await request(AuthRouter.appleLogin(accessToken: token))
    }
    public func googleLogin(accessToken token: String) async -> Result<ResponseBody<LoginResponseDto>, NetworkError> {
        await request(AuthRouter.googleLogin(accessToken: token))
    }
    
    public func refreshToken(refreshToken token: String) async -> Result<ResponseBody<RefreshDto>, NetworkError> {
        await request(.refresh(token: token))
    }
    
    /// 닉네임 설정
    public func setNickname(nickname: String) async -> Result<ResponseBody<SetNicknameDto>, NetworkError> {
        await request(AuthRouter.setNickname(nickname: nickname))
    }
}
