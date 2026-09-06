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
    private let useCase: LaunchUseCaseProtocol

    @Published var shouldNavigate = false
    @Published var showVersionUpdatePopup = false
    var shouldLaunchCameraOnStart: Bool = false

    init(useCase: LaunchUseCaseProtocol) {
        self.useCase = useCase
    }

    /// 1단계: 유저 인증 확인
    func checkAuth() async -> User? {
        Logger.info("checkAuth  유저 인증 확인하기")
        let user = await useCase.checkAuthAndGetUser()

        if let user {
            Logger.success("토큰 갱신 및 유저 정보 갱신 성공")
            AuthManager.shared.updateUser(user)
            Logger.success("유저 정보 갱신 성공: \(user.nickname ?? "익명")")

            if TrackingManager.shared.isTrackingAuthorized {
                AmplitudeManager.shared.loadAmplitude()
                AmplitudeManager.shared.setUserId(user.userId)
            }
        } else {
            Logger.warning("토큰 갱신 실패 (로그인 필요)")
            AuthManager.shared.logout()
        }

        return user
    }

    /// 2단계: 버전 확인
    func checkVersion() async {
        Logger.info("checkVersion 버전 확인하기")
        do {
            let entity = try await useCase.checkCurrentVersion()
            // 업데이트 해야함
            if entity.updateType == .none {
                Logger.info("버전 업데이트 필요: \(entity.latestVersion)")
                showVersionUpdatePopup = true
                
            } else { // 업데이트 안해도 됨
                Logger.success("최신 버전 확인")
            }
        } catch {
            Logger.error("버전 확인 실패: \(error)")
        }
    }

    /// 3단계: 카메라 실행 여부 확인
    func getLaunchCameraOnStart() {
        Logger.info("카메라 실행 여부 확인 확인하기")
        shouldLaunchCameraOnStart = useCase.getLaunchCameraOnStart()
    }
}
