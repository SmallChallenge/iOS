//
//  TimeStampApp.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import GoogleSignIn

// 화면 회전 제어를 위한 AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

@main
struct TimeStampApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Kakao SDK 초기화 (환경변수에서 가져옴)
        let kakaoAppKey = Bundle.main.kakaoAppKey
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
    
    var body: some Scene {
        WindowGroup {
            RootViewWithGlobalToast {
                AppDIContainer.shared.makeLaunchScreenView()
                // 인증 리디렉션 url 처리
                    .onOpenURL(perform: { url in
                        if (AuthApi.isKakaoTalkLoginUrl(url)) {
                            AuthController.handleOpenUrl(url: url)
                        } else {
                            GIDSignIn.sharedInstance.handle(url)
                        }
                    })
            }
        }
    }
}

// MARK: - 전역 토스트를 위한 Root View
struct RootViewWithGlobalToast<Content: View>: View {
    @StateObject private var toastManager = ToastManager.shared
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .toast(message: $toastManager.message)
    }
    
}
