//
//  CameraManager.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import AVFoundation
import UIKit
import Combine

/// 플래시 모드 3단계
enum FlashMode: CaseIterable {
    case off        // 플래시 끔
    case auto       // 자동 플래시 (어두울 때만)
    case on         // 항상 켜짐

    /// 다음 모드로 순환
    mutating func next() {
        switch self {
        case .off:
            self = .auto
        case .auto:
            self = .on
        case .on:
            self = .off
        }
    }

    /// AVCaptureDevice.FlashMode로 변환
    var avFlashMode: AVCaptureDevice.FlashMode {
        switch self {
        case .off:
            return .off
        case .auto:
            return .auto
        case .on:
            return .on
        }
    }
}

/// 카메라 하드웨어를 제어하는 매니저
/// - AVCaptureSession을 관리하고 촬영, 카메라 전환, 플래시 제어 기능 제공
final class CameraManager: NSObject, ObservableObject {

    // MARK: - Properties

    /// 카메라 입력/출력을 관리하는 세션
    let session = AVCaptureSession()

    /// 촬영된 사진을 출력하는 객체
    private let output = AVCapturePhotoOutput()

    /// 현재 사용 중인 카메라 디바이스 (전면/후면)
    private var currentDevice: AVCaptureDevice?

    /// 현재 세션에 연결된 카메라 입력
    private var currentInput: AVCaptureDeviceInput?

    /// 촬영 완료 시 호출될 클로저
    private var photoCaptureCompletion: ((UIImage?) -> Void)?

    // MARK: - Camera State

    /// 현재 전면 카메라 사용 여부
    @Published var isFrontCamera = false

    /// 플래시 모드 (off -> auto -> on 순환)
    @Published var flashMode: FlashMode = .off

    /// 카메라 권한 승인 여부
    @Published var isAuthorized = false

    // MARK: - Setup

    override init() {
        super.init()
        checkAuthorization()
    }

    /// 카메라 권한 확인 및 요청
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isAuthorized = true
            // 카메라 설정되었는지 확인
            if session.inputs.isEmpty {
                setupCamera()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
                    if granted {
                        self?.setupCamera()
                    }
                }
            }
        default:
            isAuthorized = false
        }
    }

    /// 카메라 세션 초기 설정
    private func setupCamera() {
        session.beginConfiguration()

        // 세션 품질 설정 (고화질)
        session.sessionPreset = .photo

        // 후면 카메라로 시작
        setupCameraInput(isFront: false)

        // 사진 출력 설정
        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        session.commitConfiguration()
    }

    /// 카메라 입력 설정 (전면/후면 선택)
    /// - Parameter isFront: true면 전면 카메라, false면 후면 카메라
    private func setupCameraInput(isFront: Bool) {
        // 기존 입력 제거
        if let currentInput = currentInput {
            session.removeInput(currentInput)
        }

        // 카메라 타입 선택
        let position: AVCaptureDevice.Position = isFront ? .front : .back

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
              let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        // 새 입력 추가
        if session.canAddInput(input) {
            session.addInput(input)
            currentInput = input
            currentDevice = device
        }
    }

    // MARK: - Camera Control

    /// 카메라 세션 시작
    func startSession() {
        guard !session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }

    /// 카메라 세션 중지
    func stopSession() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }

    /// 카메라 전환 (전면 ↔ 후면)
    func switchCamera() {
        session.beginConfiguration()
        isFrontCamera.toggle()
        setupCameraInput(isFront: isFrontCamera)
        session.commitConfiguration()

        // 전면 카메라로 전환 시 플래시 자동으로 끄기 (전면 카메라는 플래시 없음)
        if isFrontCamera && flashMode != .off {
            flashMode = .off
            print("⚠️ 전면 카메라로 전환하여 플래시를 껐습니다.")
        }
    }

    /// 플래시 모드 토글 (off -> auto -> on -> off 순환)
    /// - Note: 전면 카메라는 플래시가 없으므로 후면 카메라에서만 작동
    func toggleFlash() {
        // 현재 디바이스에 플래시가 있는지 확인
        guard currentDevice?.hasFlash == true else {
            print("⚠️ 현재 카메라에는 플래시가 없습니다.")
            return
        }
        flashMode.next()
    }

    /// 사진 촬영
    /// - Parameter completion: 촬영 완료 시 UIImage를 반환하는 클로저
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        photoCaptureCompletion = completion

        let settings = AVCapturePhotoSettings()

        // 플래시 설정
        // 디바이스에 플래시가 있고 후면 카메라일 때만 플래시 모드 적용
        if let device = currentDevice,
           device.hasFlash,
           device.position == .back {
            // 플래시(flashMode)로 촬영
            settings.flashMode = flashMode.avFlashMode
        } else {
            //플래시 OFF로 촬영 (전면 카메라 또는 플래시 없음)
            settings.flashMode = .off
        }

        output.capturePhoto(with: settings, delegate: self)
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraManager: AVCapturePhotoCaptureDelegate {

    /// 사진 촬영 완료 시 호출
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil,
              let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            photoCaptureCompletion?(nil)
            return
        }

        photoCaptureCompletion?(image)
        photoCaptureCompletion = nil
    }
}
