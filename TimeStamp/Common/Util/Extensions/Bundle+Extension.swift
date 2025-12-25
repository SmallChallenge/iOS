//
//  Bundle+Extension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/22/25.
//

import Foundation

extension Bundle {
    /// Info.plist에서 특정 키의 값을 가져옵니다.
    func infoDictionary(for key: String) -> String {
        guard let value = self.infoDictionary?[key] as? String else {
            fatalError("\(key) not found in Info.plist")
        }
        return value
    }

    /// Kakao App Key
    var kakaoAppKey: String {
        return infoDictionary(for: "KAKAO_APP_KEY")
    }

    /// Google Client ID
    var googleClientID: String {
        return infoDictionary(for: "GOOGLE_CLIENT_ID")
    }
}
