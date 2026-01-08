//
//  CameraViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI
import Combine
import AVFoundation

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

        // 카메라 권한 변경 감지
        cameraManager.$isAuthorized
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isAuthorized in
                guard let self = self else { return }

                if isAuthorized {
                    self.cameraManager.startSession()
                } else {
                    let status = AVCaptureDevice.authorizationStatus(for: .video)
                    if status == .denied || status == .restricted {
                        self.showPermissionAlert = true
                    }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Lifecycle

    /// 뷰가 나타날 때 카메라 시작
    func onAppear() {
        // 권한 상태 확인 (설정에서 돌아왔을 때 반영)
        // isAuthorized 변경은 init()의 sink에서 자동 처리됨
        cameraManager.checkAuthorization()
    }

    /// 뷰가 사라질 때 카메라 중지
    func onDisappear() {
        cameraManager.stopSession()
    }

    // MARK: - Camera Actions

    /// 카메라 전환 (전면 ↔ 후면)
    func switchCamera() {
        guard cameraManager.isAuthorized else {
            showPermissionAlert = true
            return
        }
        cameraManager.switchCamera()
    }

    /// 플래시 토글
    func toggleFlash() {
        guard cameraManager.isAuthorized else {
            showPermissionAlert = true
            return
        }
        cameraManager.toggleFlash()
    }

    /// 사진 촬영
    func capturePhoto() {
        guard cameraManager.isAuthorized else {
            showPermissionAlert = true
            return
        }

        #if targetEnvironment(simulator)
        // 시뮬레이터: Color.gray를 UIImage로 변환
        let dummyImage = createDummyImage()
        Task { @MainActor in
            self.capturedImage = dummyImage
        }
        #else
        // 실제 기기: 카메라로 촬영
        cameraManager.capturePhoto { [weak self] image in
            guard let self = self else { return }
            Task { @MainActor in
                self.capturedImage = image
            }
        }
        #endif
    }

    /// 시뮬레이터용 더미 이미지 생성 (회색 이미지)
    private func createDummyImage() -> UIImage? {
        let size = CGSize(width: 1000, height: 1000)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            UIColor.gray.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
