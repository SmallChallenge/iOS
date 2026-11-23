//
//  CameraScreen.swift
//  TimeStamp
//
//  Created by 임주희 on 11/22/26.
//


import SwiftUI
import AVFoundation

struct CameraScreen: View {
    
    @StateObject private var camera: CameraManager
    init (camera: CameraManager) {
        self._camera = StateObject(wrappedValue: camera)
    }
    
    @State private var zoomAtGestureStart: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .bottom) {
            CameraPreviewView(session: camera.session)
                .ignoresSafeArea()
                .pinchZoom(currentZoom: camera.displayZoom) { zoom in
                    camera.setDisplayZoom(zoom)
                }
            
            // 렌즈 전환 버튼 (줌)
            HStack(spacing: 12) {
                ForEach(camera.lensOptions, id: \.self) { option in
                    Button {
                        camera.setDisplayZoom(option, animated: true)
                        zoomAtGestureStart = option
                    } label: {
                        Text(label(for: option))
                            .font(.Caption)
                            .foregroundStyle(isSelected(option) ? .yellow : .white)
                            .frame(width: 40, height: 40)
                            .background(.black.opacity(0.5), in: Circle())
                    }
                }
            }
            .padding(.bottom, 10)
        }
        .onAppear {
            camera.startSession()
            zoomAtGestureStart = 1.0
        }
    }

    private func label(for value: CGFloat) -> String {
        value == value.rounded() ? "\(Int(value))x" : String(format: "%.1fx", value)
    }

    private func isSelected(_ option: CGFloat) -> Bool {
        abs(camera.displayZoom - option) < 0.05
    }
}
