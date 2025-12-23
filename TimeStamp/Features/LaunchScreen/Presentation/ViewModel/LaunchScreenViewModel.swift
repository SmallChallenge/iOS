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
    func didRefreshToken(success: Bool) {
        // 메인 스레드에서 호출됨
        if success {
            print("✅ 토큰 갱신 성공 → 메인 화면으로")
            // TODO: 유저 정보 가져오기
        } else {
            print("⚠️ 토큰 갱신 실패 → 메인 화면으로 (로그인 필요)")
        }

        // 성공/실패 상관없이 메인 화면으로 이동
        shouldNavigate = true
    }
}
