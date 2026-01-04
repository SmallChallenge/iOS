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
        
        // 카카오톡 실행 가능 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            loginWithKakaoApp()
        } else {
            // 웹으로 로그인
            loginWithKakaoWeb()
        }       
    }
    
    private func loginWithKakaoApp(){
        UserApi.shared.loginWithKakaoTalk {[weak self] (oauthToken, error) in
            if let error = error {
                // 에러 처리
                self?.delegate?.didLogin(type: .kakao, didReceiveToken: nil, error: error)
            }
            else {
                print("loginWithKakaoTalk() success.")

                // 성공 시 동작 구현
                _ = oauthToken
                let accessToken = oauthToken?.accessToken
                self?.delegate?.didLogin(type: .kakao, didReceiveToken: accessToken, error: nil)
            }
        }
    }
    private func loginWithKakaoWeb(){
        UserApi.shared.loginWithKakaoAccount {[weak self] (oauthToken, error) in
                if let error = error {
                    // 에러 처리
                    self?.delegate?.didLogin(type: .kakao, didReceiveToken: nil, error: error)
                }
                else {
                    print("loginWithKakaoAccount() success.")

                    // 성공 시 동작 구현
                    _ = oauthToken
                    let accessToken = oauthToken?.accessToken
                    self?.delegate?.didLogin(type: .kakao, didReceiveToken: accessToken, error: nil)
                }
            }
    }
    
    // 카카오앱, 웹 선택화면
    private func loginWithAppAndWeb(){
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

