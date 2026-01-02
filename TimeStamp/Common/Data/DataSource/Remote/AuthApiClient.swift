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
    
    // 약관 동의 (계정 활성화)
    case activeAccount(
        accessToken: String,
        agreedToPrivacyPolicy: Bool,
        agreedToTermsOfService: Bool,
        agreedToMarketing: Bool
    )
    
    // 토큰 재발급
    case refresh(token: String)
    // 로그아웃
    // 회원탈퇴
    
    // 닉네임 중복 확인
    // 닉네임 설정
    case setNickname(nickname: String, accessToken: String?)
    
    // 가입 취소
    case cancelRegisteration(accessToken: String)
    
    // 회원탈퇴
    //case withdrawal
    
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
            
        case .activeAccount:
            "api/v1/auth/terms-agreement"
            
        case .cancelRegisteration:
            "/api/v1/auth/cancel-registration"
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
            
        case let .setNickname(nickname, _):
            let params: Parameters = [
                "nickname" : nickname,
            ]
            return params
            
        case let .activeAccount(_, privacyPolicy, termsOfService, marketing):
            let params: Parameters = [
                "agreedToPrivacyPolicy" : privacyPolicy,
                "agreedToTermsOfService" : termsOfService,
                "agreedToMarketing" : marketing,
                "allRequiredTermsAgreed" : (privacyPolicy && termsOfService),
            ]
            return params
            
        case .cancelRegisteration:
            return nil
        }
    }
    
    public var headers: HTTPHeaders? {
        switch self {
        case let .activeAccount(token, _, _, _):
            return ["Authorization": "Bearer \(token)"]
            
        case let .cancelRegisteration(token):
            return ["Authorization": "Bearer \(token)"]
            
        case let .setNickname(_, token):
            guard let token else { return nil }
            return ["Authorization": "Bearer \(token)"]
        default:
            return nil
        }
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
    
    // 계정활성화 (약관동의)
    func activeAccount(
        accessToken token: String, 
        agreedToPrivacyPolicy: Bool,
        agreedToTermsOfService: Bool,
        agreedToMarketing: Bool
    ) async -> Result<ActiveAccountDto, NetworkError>
    /// 토큰 재발급
    func refreshToken(refreshToken token: String) async -> Result<RefreshDto, NetworkError>
    // 로그아웃
    // 회원탈퇴

    // 닉네임 중복확인
    // 닉네임 설정
    func setNickname(nickname: String, accessToken token: String?) async -> Result<SetNicknameDto, NetworkError>
    
    /// 가입 취소
    func cancelRegisteration(accessToken: String) async -> Result<CancelRegisterationDto, NetworkError>

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

    public func refreshToken(refreshToken token: String) async -> Result<RefreshDto, NetworkError> {
        await request(.refresh(token: token))
    }

    /// 닉네임 설정
    public func setNickname(nickname: String, accessToken token: String?) async -> Result<SetNicknameDto, NetworkError> {
        await request(AuthRouter.setNickname(nickname: nickname, accessToken: token))
    }
    
    /// 약관 동의 받기 (계정 활성화)
    public func activeAccount(accessToken token: String, agreedToPrivacyPolicy: Bool, agreedToTermsOfService: Bool, agreedToMarketing: Bool) async -> Result<ActiveAccountDto, NetworkError> {
        await request(.activeAccount(accessToken: token, agreedToPrivacyPolicy: agreedToPrivacyPolicy, agreedToTermsOfService: agreedToTermsOfService, agreedToMarketing: agreedToMarketing))
    }
    
    /// 가입 취소
    public func cancelRegisteration(accessToken: String) async -> Result<CancelRegisterationDto, NetworkError> {
        await request(.cancelRegisteration(accessToken: accessToken))
    }
}

public struct CancelRegisterationDto: Codable {
    let userId: Int
    let deletedAt: String
}
