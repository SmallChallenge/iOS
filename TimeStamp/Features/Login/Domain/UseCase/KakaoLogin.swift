//
//  KakaoLogin.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class KakaoLogin: SocialLoginProtocol {
    var delegate: SocialLoginDelegate?
    
    func login() {
        UserApi.shared.loginWithKakao(BridgeConfiguration(), loginProperties: LoginConfiguration()) { [weak self] token, error in
            if let error = error {
                // 에러 처리
                self?.delegate?.didLogin(type: .kakao, didReceiveToken: nil, error: error)
                return
            }
            
            // 성공 시 동작 구현
            _ = token
            let accessToken = token?.accessToken
            self?.delegate?.didLogin(type: .kakao, didReceiveToken: accessToken, error: nil)
        }
    }
}

