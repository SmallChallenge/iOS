//
//  SocialLoginProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/13/25.
//

import Foundation
import UIKit

enum LoginType: String {
    case  kakao, google, apple
}

// MARK: - SocialLoginProtocol

protocol SocialLoginProtocol {
    var delegate: SocialLoginDelegate? { get set }
    func login()
}

extension SocialLoginProtocol {
    var viewController: UIViewController? {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: \.isKeyWindow),
              let rootVC = window.rootViewController else {
            return nil
        }

        var topController = rootVC
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        return topController
    }
}

// MARK: - SocialLoginDelegate

protocol SocialLoginDelegate {
    func didLogin(type: LoginType, didReceiveToken token: String?, error: Error?)
}


