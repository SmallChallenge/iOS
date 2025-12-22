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
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "971afea14146fb0c32c67bff9840350e")
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
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
