//
//  CameraViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI
import Combine

/// 카메라 화면의 비즈니스 로직을 관리하는 ViewModel
@MainActor
final class CameraViewModel: ObservableObject {

    // MARK: - Properties

    /// 카메라 하드웨어 제어 매니저
    let cameraManager = CameraManager()

    /// 촬영된 사진
    @Published var capturedImage: UIImage?

    /// 카메라 권한이 없을 때 알림 표시
    @Published var showPermissionAlert = false

    /// 플래시 모드 (View에서 접근용)
    @Published var flashMode: FlashMode = .off

    // Combine 구독
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init

    init() {
        // CameraManager의 플래시 모드를 ViewModel과 동기화
        cameraManager.$flashMode
            .assign(to: &$flashMode)
    }

    // MARK: - Lifecycle

    /// 뷰가 나타날 때 카메라 시작
    func onAppear() {
        // 권한 상태 확인 (설정에서 돌아왔을 때 반영)
        cameraManager.checkAuthorization()

        if cameraManager.isAuthorized {
            cameraManager.startSession()
        } else {
            showPermissionAlert = true
        }
    }

    /// 뷰가 사라질 때 카메라 중지
    func onDisappear() {
        cameraManager.stopSession()
    }

    // MARK: - Camera Actions

    /// 카메라 전환 (전면 ↔ 후면)
    func switchCamera() {
        cameraManager.switchCamera()
    }

    /// 플래시 토글
    func toggleFlash() {
        cameraManager.toggleFlash()
    }

    /// 사진 촬영
    func capturePhoto() {
        cameraManager.capturePhoto { [weak self] image in
            guard let self = self else { return }
            Task { @MainActor in
                self.capturedImage = image
                // TODO: 촬영된 사진 처리 (저장, 프리뷰 등)
            }
        }
    }
}
