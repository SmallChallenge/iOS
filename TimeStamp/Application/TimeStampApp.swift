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
import GoogleMobileAds


@main
struct TimeStampApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
        // Kakao SDK 초기화 (환경변수에서 가져옴)
        let kakaoAppKey = Bundle.main.kakaoAppKey
        KakaoSDK.initSDK(appKey: kakaoAppKey)

        #if DEBUG
        // 애드몹 초기화 (Initialize the Google Mobile Ads SDK.)
        MobileAds.shared.start()
        #endif

        // Refresh Control 색상 설정
        UIRefreshControl.appearance().tintColor = UIColor(Color.neon300)
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

// MARK: - 화면 회전 제어를 위한 AppDelegate
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}

// MARK: - 
import UIKit

extension UIApplication {
    /// 현재 앱에서 실제로 사용자 눈에 보이는 가장 최상단의 뷰 컨트롤러를 찾습니다.
    @MainActor
    func getTopMostViewController() -> UIViewController? {
        let scene = self.connectedScenes.first as? UIWindowScene
        var topController = scene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
        
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        
        return topController
    }
}
