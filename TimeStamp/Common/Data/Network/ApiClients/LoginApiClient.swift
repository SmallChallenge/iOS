//
//  LoginRouter.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation
import Alamofire

// 예시로 만들어 보는중
public enum LoginRouter {
    
    case kakaoLogin
    case appleLogin
    case googleLogin
}
extension LoginRouter: Router {
   

    public var baseURL: URL {
        URL(string: "https://baseurl.com/v2/")!
    }
    
    public var path: String {
        switch self {
        case .appleLogin: "v1/login/apple/"
        case .kakaoLogin: "v1/login/kakao"
        case .googleLogin: "v1/login/google/"
        }
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public var parameters: Parameters? {
        nil
    }
    
    public var headers: HTTPHeaders? {
        nil
    }
    
    public var encoding: Encoding? {
        nil
    }
    
}

// MARK: - API Client

public class LoginApiClient: ApiClient<LoginRouter> {
    public func kakaoLogin() async -> Result<LoginResponseDto, NetworkError> {
        await request(LoginRouter.kakaoLogin)
    }
    public func appleLogin() async -> Result<LoginResponseDto, NetworkError> {
        await request(LoginRouter.appleLogin)
    }
    public func googleLogin() async -> Result<LoginResponseDto, NetworkError> {
        await request(LoginRouter.googleLogin)
    }
}




public struct LoginResponseDto: Codable {
    let accessToken: String
    
}
