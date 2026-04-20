//
//  AppConstants.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation

enum AppConstants {

    // MARK: - URLs

    enum URLs {
        /// 이용약관
        static let termsOfService = "https://dear-building-cd1.notion.site/3100e394538c806f8d7fc9355045bd7f?source=copy_link"
        /// 개인정보 처리방침
        static let privacyPolicy = "https://dear-building-cd1.notion.site/3100e394538c803d93c6de93f47c45ce?source=copy_link"
        
        /// 오픈소스라이선스
        static let openSourceLicense = "https://dear-building-cd1.notion.site/3100e394538c8014a97affaade263397?source=copy_link"
        
        // 지원 메일
        static let supportEmail = "stampy7373@gmail.com"
    }

    // MARK: - App Info

    enum AppInfo {
        static let appNameKr = "스탬픽"
        static let appNameEn = "Stampic"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    // MARK: - UI

//    enum UI {
//        static let animationDuration: TimeInterval = 0.3
//        static let cornerRadius: CGFloat = 12
//    }

    // MARK: - Limits

    enum Limits {
        static let maxNicknameLength = 10
        static let minNicknameLength = 2
        static let maxImageSize = 10 * 1024 * 1024 // 10MB
        
        static let maxLogCount: Int = 20
        static let warningLogCount: Int = (maxLogCount - 2)
    }
    
    // MARK: SDK key
    enum SDKKeys {
        //  TODO: 앰플리튜드 키 옮기기
        #if DEBUG
        static let ad_banner = "ca-app-pub-3940256099942544/2435281174"
        static let ad_reward = "ca-app-pub-3940256099942544/1712485313"
        #else
        static let ad_banner = "ca-app-pub-7896890737820919/2318652866"
        static let ad_reward = "ca-app-pub-7896890737820919/7532361228"
        #endif
    }
}
