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
    
    
    // 권장 업데이트 안내
    @Published var showVersionOptionalUpdatePopupMessage = false
    // 필수 없데이트 안내
    @Published var showVersionRequiredUpdatePopupMessage = false

    
    
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
            // 버전 체크
            switch entity {
            case .required: // 필수 업데이트 안내
                Logger.info("필수 업데이트 안내")
                showVersionRequiredUpdatePopupMessage = true
                
            case .optional: //권장 업데이트 안내
                Logger.info("권장 업데이트 안내")
                showVersionOptionalUpdatePopupMessage = true
                
            case .none: //업데이트 안해도 됨.
                Logger.success("최신 버전 확인")
                
            }
        } catch {
            Logger.error("버전 확인 실패: \(error)")
        }
    }
    
    // 권장업데이트 '나중에' 누름, 해당 시점과 버전을 기록하기
    func saveRecommendedUpdateDismissal() {
        useCase.saveRecommendedUpdateDismissal()
    }

    /// 3단계: 카메라 실행 여부 확인
    func getLaunchCameraOnStart() {
        Logger.info("카메라 실행 여부 확인 확인하기")
        shouldLaunchCameraOnStart = useCase.getLaunchCameraOnStart()
    }
}
