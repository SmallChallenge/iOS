//
//  EmailHelper.swift
//  TimeStamp
//
//  Created by 임주희 on 3/3/26.
//

import Foundation
import UIKit

struct EmailHelper {
    static func getSupportEmailBody(userId: String) -> String {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        let appVersion = "\(version)(\(build))"
        
        let deviceModel = UIDevice.current.modelName
        let osVersion = UIDevice.current.systemVersion
        
        return """
        문의 내용을 상세히 작성해주세요.
        
        
        ---------------
        앱 버전: iOS \(appVersion)
        사용자 ID: \(userId)
        기기 정보: \(deviceModel) (iOS \(osVersion))
        ---------------
        """
    }
}
