//
//  AppInfo.swift
//  TimeStamp
//
//  Created by 임주희 on 6/30/26.
//

import Foundation

enum AppInfo {
    static let appNameKr = "스탬픽"
    static let appNameEn = "Stampic"
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    static let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
}
