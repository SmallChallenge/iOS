//
//  RecommendedUpdateDismissal.swift
//  TimeStamp
//
//  Created by 임주희 on 10/11/26.
//

import Foundation

// MARK: - 권장 업데이트 '나중에'를 누른 시점과 앱 버전 저장
public struct RecommendedUpdateDismissal: Codable {
    let appVersion: String
    let dismissedAt: Date
}
