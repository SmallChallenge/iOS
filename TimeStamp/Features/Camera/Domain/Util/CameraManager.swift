//
//  CameraManager.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import AVFoundation
import UIKit
import Combine
import AVFAudio


/// 카메라 하드웨어를 제어하는 매니저
/// - AVCaptureSession을 관리하고 촬영, 카메라 전환, 플래시 제어 기능 제공
final class CameraManager: NSObject, ObservableObject {

    // MARK: - Properties

    /// 카메라 입력/출력을 관리하는 세션
    let session = AVCaptureSession()

    /// 비디오 데이터 출력 (무음 촬영용)
    private let videoOutput = AVCaptureVideoDataOutput()

    /// 사진 출력용 큐
    private let sessionQueue = DispatchQueue(label: "com.timestamp.videoQueue")

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
    
    /// 촬영 시 적용할 비율 (화면의 선택값과 동기화)
    var captureAspectRatio: CameraAspectRatio = .threeFour
    
    // MARK: - Zoom State

    /// 표시용 줌 배율 (0.5x, 1x, 2x ...)
    @Published var displayZoom: CGFloat = 1.0
    /// 렌즈 버튼용 배율 목록 ([0.5, 1, 2] 등)
    @Published var lensOptions: [CGFloat] = [1.0]

    /// raw zoom → 표시 배율 변환 기준 (초광각 있으면 보통 2.0)
    private var baseFactor: CGFloat = 1.0
    private let maxDisplayZoom: CGFloat = 10.0
    

    // MARK: - Setup

    override init() {
        super.init()
        
        checkAuthorization()
    }
    
    deinit {
        session.stopRunning()
    }

    /// 카메라 권한 확인 및 요청
    func checkAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            isAuthorized = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                DispatchQueue.main.async {
                    self?.isAuthorized = granted
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

        // 비디오 데이터 출력 설정 (무음 촬영용)
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(self, queue: sessionQueue)
            // 비디오 방향 설정
            if let connection = videoOutput.connection(with: .video) {
                connection.videoOrientation = .portrait
            }
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

        let device: AVCaptureDevice?
        if isFront {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        } else {
            // 렌즈 많은 가상 디바이스 우선, 없으면 기본 광각
            device = AVCaptureDevice.default(.builtInTripleCamera, for: .video, position: .back)
            ?? AVCaptureDevice.default(.builtInDualWideCamera, for: .video, position: .back)
            ?? AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back)
            ?? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        }
        guard let device,
              let input = try? AVCaptureDeviceInput(device: device) else { return }


        // 새 입력 추가
        if session.canAddInput(input) {
            session.addInput(input)
            currentInput = input
            currentDevice = device
            setupZoomInfo(for: device)   // 줌 정보 갱신
        }
    }

    // MARK: - Camera Control

    /// 카메라 세션 시작
    func startSession() {
        guard !session.isRunning else { return }

        // 세션이 비어있으면 먼저 설정
        if session.inputs.isEmpty {
            setupCamera()
        }

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
            Logger.warning("전면 카메라로 전환하여 플래시를 껐습니다.")
        }
    }

    /// 플래시 모드 토글 (off -> auto -> on -> off 순환)
    /// - Note: 전면 카메라는 플래시가 없으므로 후면 카메라에서만 작동
    func toggleFlash() {
        // 현재 디바이스에 플래시가 있는지 확인
        guard currentDevice?.hasFlash == true else {
            Logger.warning("현재 카메라에는 플래시가 없습니다.")
            return
        }
        flashMode.next()
    }

    /// 사진 촬영 (무음)
    /// - Parameter completion: 촬영 완료 시 UIImage를 반환하는 클로저
    func capturePhoto(completion: @escaping (UIImage?) -> Void) {
        photoCaptureCompletion = completion

        // 플래시 설정
        if let device = currentDevice,
           device.hasFlash,
           device.position == .back,
           flashMode != .off {
            do {
                try device.lockForConfiguration()

                // 플래시 켜기
                if device.hasTorch {
                    switch flashMode {
                    case .on:
                        try device.setTorchModeOn(level: 1.0)
                    case .auto:
                        // auto는 현재 밝기를 체크하기 어려우므로 off로 처리
                        device.torchMode = .off
                    case .off:
                        device.torchMode = .off
                    }
                }

                device.unlockForConfiguration()
            } catch {
                Logger.error("플래시 설정 실패: \(error)")
            }
        }
    }
    
    // MARK: - Zoom

    private func setupZoomInfo(for device: AVCaptureDevice) {
        let switchOvers = device.virtualDeviceSwitchOverVideoZoomFactors.map { CGFloat(truncating: $0) }
        let hasUltraWide = device.constituentDevices.contains { $0.deviceType == .builtInUltraWideCamera }

        baseFactor = (hasUltraWide ? switchOvers.first : nil) ?? 1.0

        var options: [CGFloat] = []
        if hasUltraWide { options.append(0.5) }
        options.append(1.0)
        let teleStart = hasUltraWide ? 1 : 0
        if switchOvers.count > teleStart {
            options += switchOvers[teleStart...].map { ($0 / baseFactor * 10).rounded() / 10 }
        }

        DispatchQueue.main.async {
            self.lensOptions = options
            self.displayZoom = 1.0
        }
        applyZoom(display: 1.0)
    }

    /// 표시 배율(0.5x, 1x, 3x...)로 줌 설정
    func setDisplayZoom(_ display: CGFloat, animated: Bool = false) {
        applyZoom(display: display, animated: animated)
    }

    private func applyZoom(display: CGFloat, animated: Bool = false) {
        guard let device = currentDevice else { return }

        let raw = display * baseFactor
        let maxRaw = min(device.maxAvailableVideoZoomFactor, maxDisplayZoom * baseFactor)
        let clamped = min(max(raw, device.minAvailableVideoZoomFactor), maxRaw)

        do {
            try device.lockForConfiguration()
            if animated {
                device.ramp(toVideoZoomFactor: clamped, withRate: 8.0)
            } else {
                device.videoZoomFactor = clamped
            }
            device.unlockForConfiguration()

            DispatchQueue.main.async {
                self.displayZoom = clamped / self.baseFactor
            }
        } catch {
            Logger.error("줌 설정 실패: \(error)")
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraManager: AVCaptureVideoDataOutputSampleBufferDelegate {

    /// 비디오 프레임 수신 시 호출 (무음 촬영)
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // 촬영 요청이 있을 때만 프레임 캡처
        guard let completion = photoCaptureCompletion else { return }

        // CMSampleBuffer를 UIImage로 변환
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            photoCaptureCompletion = nil
            return
        }

        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()

        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            DispatchQueue.main.async {
                completion(nil)
            }
            photoCaptureCompletion = nil
            return
        }
        
        // 선택한 비율로 중앙 크롭
        let croppedCGImage = crop(cgImage, toRatio: captureAspectRatio.value)


        // 이미지 방향 조정
        let image = UIImage(cgImage: croppedCGImage, scale: 1.0, orientation: getImageOrientation())

        // 플래시 끄기
        if let device = currentDevice, device.hasTorch {
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {
                Logger.error("플래시 끄기 실패: \(error)")
            }
        }

        DispatchQueue.main.async {
            completion(image)
        }

        photoCaptureCompletion = nil
    }

    /// 현재 카메라 위치에 따른 이미지 방향 반환
    private func getImageOrientation() -> UIImage.Orientation {
        if isFrontCamera {
            return .upMirrored
        } else {
            return .up
        }
    }
    
    /// 이미지를 가로/세로 비율에 맞게 중앙 크롭
    private func crop(_ image: CGImage, toRatio ratio: CGFloat) -> CGImage {
        let w = CGFloat(image.width)
        let h = CGFloat(image.height)
        var rect = CGRect(x: 0, y: 0, width: w, height: h)

        if w / h > ratio {
            // 가로가 넓음 → 좌우를 자름
            let newW = h * ratio
            rect = CGRect(x: (w - newW) / 2, y: 0, width: newW, height: h)
        } else {
            // 세로가 김 → 위아래를 자름
            let newH = w / ratio
            rect = CGRect(x: 0, y: (h - newH) / 2, width: w, height: newH)
        }
        return image.cropping(to: rect.integral) ?? image
    }
}


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

