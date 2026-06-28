//
//  CameraPreviewView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI
import AVFoundation

/// 카메라 프리뷰를 표시하는 뷰
/// - AVCaptureVideoPreviewLayer를 UIView로 감싸서 SwiftUI에서 사용
struct CameraPreviewView: UIViewRepresentable {

    /// 카메라 세션
    let session: AVCaptureSession

    // MARK: - UIViewRepresentable

    func makeUIView(context: Context) -> CameraPreviewUIView {
        let view = CameraPreviewUIView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreviewUIView, context: Context) {
        // 세션 업데이트 시 필요한 작업
    }
}

/// 카메라 프리뷰를 담는 UIView
class CameraPreviewUIView: UIView {

    /// AVFoundation의 카메라 프리뷰 레이어
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        let layer = AVCaptureVideoPreviewLayer()
        layer.frame = bounds
        return layer
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(previewLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // 뷰 크기 변경 시 프리뷰 레이어도 조정
        previewLayer.frame = bounds
    }
}
