//
//  TrackingManager.swift
//  TimeStamp
//
//  Created by Claude on 1/7/26.
//

import Foundation
import AppTrackingTransparency
import Combine

/// App Tracking Transparency (ATT) 권한 관리
final class TrackingManager: ObservableObject {

    static let shared = TrackingManager()

    // MARK: - Published Properties

    /// 현재 추적 권한 상태
    @Published private(set) var trackingStatus: ATTrackingManager.AuthorizationStatus = .notDetermined

    /// 추적이 허용되었는지 여부
    var isTrackingAuthorized: Bool {
        trackingStatus == .authorized
    }

    // MARK: - Init

    private init() {
        // 앱 시작 시 현재 권한 상태 로드
        updateTrackingStatus()
    }

    // MARK: - Public Methods

    /// 추적 권한 요청
    /// - Returns: 사용자가 허용했는지 여부
    @MainActor
    func requestTrackingAuthorization() async -> Bool {
        // 이미 결정된 상태라면 다시 요청하지 않음
        if trackingStatus != .notDetermined {
            Logger.info("이미 추적 권한이 결정됨: \(trackingStatus.description)")
            return isTrackingAuthorized
        }

        Logger.info("추적 권한 요청 시작")

        let status = await ATTrackingManager.requestTrackingAuthorization()
        trackingStatus = status

        Logger.success("추적 권한 결과: \(status.description)")

        return isTrackingAuthorized
    }

    /// 현재 추적 권한 상태 확인
    func checkTrackingStatus() -> ATTrackingManager.AuthorizationStatus {
        updateTrackingStatus()
        return trackingStatus
    }

    // MARK: - Private Methods

    /// 추적 권한 상태 업데이트
    private func updateTrackingStatus() {
        trackingStatus = ATTrackingManager.trackingAuthorizationStatus
    }
}

// MARK: - ATTrackingManager.AuthorizationStatus Extension

extension ATTrackingManager.AuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined:
            return "미결정"
        case .restricted:
            return "제한됨"
        case .denied:
            return "거부됨"
        case .authorized:
            return "허용됨"
        @unknown default:
            return "알 수 없음"
        }
    }
}
