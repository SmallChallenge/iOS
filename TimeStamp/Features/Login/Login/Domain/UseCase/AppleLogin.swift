//
//  AppleLogin.swift
//  TimeStamp
//
//  Created by 임주희 on 12/13/25.
//

import Foundation
import AuthenticationServices
import UIKit

/*
 서버에게 주는 client Id: bundle id 였음..
 */

final class AppleLogin: NSObject, SocialLoginProtocol {

    var delegate: SocialLoginDelegate?

    @Keychain(key: "appleEmail")
    private var appleEmail: String?

    @Keychain(key: "appleFullName")
    private var fullName: String?

    func login() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.email, .fullName]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleLogin: ASAuthorizationControllerDelegate {
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        switch authorization.credential {
        case let appleIdCredential as ASAuthorizationAppleIDCredential:
            if let identityToken = appleIdCredential.identityToken,
               let token = String(data: identityToken, encoding: .utf8) {

                // 최초에만 주는 값 (이메일, 이름) 저장
                if let email = appleIdCredential.email {
                    appleEmail = email
                }

                if let fullNameComponent = appleIdCredential.fullName {
                    let fullName = PersonNameComponentsFormatter().string(from: fullNameComponent)
                    if fullName.isNotEmpty {
                        self.fullName = fullName
                    }
                }

                // 로그인 성공 값 돌려보내기
                delegate?.didLogin(type: .apple, didReceiveToken: token, error: nil)
            }
        default:
            delegate?.didLogin(type: .apple, didReceiveToken: nil, error: nil)
            break
        }
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        // 사용자가 로그인 취소 또는 에러 발생 시
        delegate?.didLogin(type: .apple, didReceiveToken: nil, error: error)
    }
}

// 애플로그인 화면 띄우기
extension AppleLogin: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = viewController?.view.window else {
            // fallback: 현재 active window 찾기
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                return scene.windows.first { $0.isKeyWindow } ?? UIWindow()
            }
            return UIWindow()
        }
        return window
    }
}
