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
        안녕하세요, 스탬픽 팀입니다 :)
        문의 내용을 아래에 작성해 주시면 빠르게 답변드릴게요!

        ——————————————
        문의 유형 (해당하는 항목에 ✅ 표시해 주세요)
        [ ] 버그 신고
        [ ] 기능 제안
        [ ] 계정 문의
        [ ] 기타
        ——————————————

        📝 문의 내용을 여기에 작성해 주세요.

        ——————————————
        [자동 수집 정보 - 수정하지 마세요]
        앱 버전: iOS \(appVersion)
        사용자 ID: \(userId)
        기기 플랫폼: iOS
        OS 버전: iOS \(osVersion)
        기기 모델: \(deviceModel) 
        ---------------
        """
    }
}
