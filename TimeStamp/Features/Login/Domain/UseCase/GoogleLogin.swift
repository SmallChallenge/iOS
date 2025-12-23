//
//  GoogleLogin.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift
import UIKit

final class GoogleLogin: SocialLoginProtocol {
    var delegate: SocialLoginDelegate?
    
    func login() {
        guard let rootViewController: UIViewController = viewController else {
            print("❌ 구글 로그인 실패: rootVC 못찾음")
            return
        }
        
        // 구글 로그인
        GIDSignIn.sharedInstance.signIn(
            withPresenting: rootViewController) { [weak self] signInResult, error in
                
                if error != nil {
                    self?.delegate?.didLogin(type: .google, didReceiveToken: nil, error: error)
                    return
                }
                
                guard let result = signInResult else {
                    self?.delegate?.didLogin(type: .google, didReceiveToken: nil, error: error)
                    return
                }
                let user = result.user
                
                // let givenName = user.profile?.givenName ?? "" //사용자의 이름
                // let oauthId = user.userID ?? "" //사용자의 고유 ID
                let idToken = user.idToken?.tokenString ?? ""//사용자의 ID 토큰

                self?.delegate?.didLogin(type: .google, didReceiveToken: idToken, error: nil)
                
            }
    }
    
   /*
    /// 현재 구글 로그인 상태를 확인하고, 로그인된 사용자의 정보를 업데이트한다.
    /// 로그인된 경우 사용자 정보를 가져와서 저장하며, 로그인되지 않은 경우 에러 메시지를 설정한다.
    /// GIDSignIn.sharedInstance.currentUser는 현재 로그인된 사용자를 나타내며, 사용자가 로그인되어 있지 않으면 nil을 반환한다.
    func checkUserInfo() {
        if GIDSignIn.sharedInstance.currentUser != nil { //현재 사용자가 로그인되어 있는지 확인
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else {
                return
            }
            let givenName = user.profile?.givenName ?? "" //사용자의 이름
            let oauthId = user.userID ?? "" //사용자의 고유 ID
            let idToken = user.idToken?.tokenString ?? ""//사용자의 ID 토큰

        } else {
            print(">>>>> checkUserInfo error: Not Logged In")
        }
    }
    
    func restorePreviousSignIn(){
        // 구글 로그인 - 사용자의 로그인 상태 복원 시도
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            // Check if `user` exists; otherwise, do something with `error`
        }
    }
    
    */
    
}
