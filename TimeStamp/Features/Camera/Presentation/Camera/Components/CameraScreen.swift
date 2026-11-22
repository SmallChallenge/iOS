//
//  CameraScreen.swift
//  TimeStamp
//
//  Created by 임주희 on 11/22/26.
//


import SwiftUI
import AVFoundation

struct CameraScreen: View {
    @Binding private var aspectRatio: CameraAspectRatio
    private let session: AVCaptureSession

    init(aspectRatio: Binding<CameraAspectRatio>, session: AVCaptureSession) {
        self._aspectRatio = aspectRatio
        self.session = session
    }

    var body: some View {
        CameraPreviewView(session: session)
            .aspectRatio(3/4, contentMode: .fit)
            .overlay {
                GeometryReader { geo in
                    let maskHeight = aspectRatio == .square ? (geo.size.height - geo.size.width) / 2 : 0

                    VStack(spacing: 0) {
                        Color.gray900.opacity(0.6).frame(height: maskHeight)
                        Spacer()
                        Color.gray900.opacity(0.6).frame(height: maskHeight)
                    }
                    .animation(.easeInOut(duration: 0.2), value: aspectRatio)
                }
                .allowsHitTesting(false)
            }
    }
}
