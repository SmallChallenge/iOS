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
        static let termsOfService = "https://sage-hare-ff7.notion.site/2d5f2907580d80df9a21f95acd343d3f?source=copy_link"
        /// 개인정보 처리방침
        static let privacyPolicy = "https://sage-hare-ff7.notion.site/2d5f2907580d80eda745ccfbda543bc5?source=copy_link"
        //static let supportEmail = "support@stampy.kr"
        
        /// 오픈소스라이선스
        static let openSourceLicense = "https://sage-hare-ff7.notion.site/2d8f2907580d80e4accee06ce4da69cd?source=copy_link"
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
        static let warningLogCount: Int = 18
    }
}
