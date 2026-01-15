//
//  LaunchScreenViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class LaunchScreenViewModel: ObservableObject {

    private let useCase: LaunchScreenUseCaseProtocol

    @Published var shouldNavigate = false

    init(useCase: LaunchScreenUseCaseProtocol) {
        self.useCase = useCase
    }

    /// 앱 시작 시 인증 체크 (Task는 ViewModel이 관리)
    func checkAuth() {
        Task {
            await useCase.refreshToken()
        }
    }
}

// MARK: - LaunchScreenUseCaseDelegate

extension LaunchScreenViewModel: LaunchScreenUseCaseDelegate {
    func didRefreshToken(user: User?) {
        // 메인 스레드에서 호출됨
        if let user {
            Logger.success("토큰 갱신 및 유저 정보 갱신 성공 → 메인 화면으로")
            
            // 유저정보 저장
            AuthManager.shared.updateUser(user)
            Logger.success("유저 정보 갱신 성공: \(user.nickname ?? "익명")")
        } else {
            Logger.warning("토큰 갱신 실패 → 메인 화면으로 (로그인 필요)")
            AuthManager.shared.logout()
        }
        
        // Amplitude userId 설정 (로그인 이벤트는 발생시키지 않음)
        if TrackingManager.shared.isTrackingAuthorized {
            AmplitudeManager.shared.loadAmplitude()
            AmplitudeManager.shared.setUserId(user?.userId)
        }
        
        // 성공/실패 상관없이 메인 화면으로 이동
        shouldNavigate = true
    }
}
