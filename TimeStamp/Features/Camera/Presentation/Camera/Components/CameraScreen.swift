//
//  CameraScreen.swift
//  TimeStamp
//
//  Created by 임주희 on 11/22/26.
//


import SwiftUI
import AVFoundation

struct CameraScreen: View {
    
    @ObservedObject private var cameraManager: CameraManager
    @Binding private var aspectRatio: CameraAspectRatio
    init (camera: CameraManager, aspectRatio: Binding<CameraAspectRatio>) {
        self.cameraManager = camera
        self._aspectRatio = aspectRatio
    }
    
    @State private var zoomAtGestureStart: CGFloat = 1.0

    var body: some View {
        ZStack(alignment: .bottom) {
            
            //Color.black.ignoresSafeArea()
            
            // 프리뷰: 선택한 비율로 영역을 제한 (resizeAspectFill이라 자동으로 잘려 보임)
            CameraPreviewView(session: cameraManager.session)
                .aspectRatio(aspectRatio.value, contentMode: .fit)
                .clipped()
                .frame(maxHeight: .infinity, alignment: .center)
                .pinchZoom(currentZoom: cameraManager.displayZoom) { zoom in
                    cameraManager.setDisplayZoom(zoom)
                }
            
            // 렌즈 전환 버튼 (줌)
            HStack(spacing: 12) {
                ForEach(cameraManager.lensOptions, id: \.self) { option in
                    Button {
                        cameraManager.setDisplayZoom(option, animated: true)
                        zoomAtGestureStart = option
                    } label: {
                        Text(Zoomlabel(for: option))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(isSelected(zoom: option) ? .yellow : .white)
                            .frame(width: 40, height: 40)
                            .background(.black.opacity(0.5), in: Circle())
                    }
                }
            }
            .padding(.bottom, 10)
        }
        //.animation(.easeInOut(duration: 0.2), value: aspectRatio)
        
        .onAppear {
            zoomAtGestureStart = 1.0
        }
    }

    private func Zoomlabel(for value: CGFloat) -> String {
        value == value.rounded() ? "\(Int(value))x" : String(format: "%.1fx", value)
    }

    private func isSelected(zoom option: CGFloat) -> Bool {
        abs(cameraManager.displayZoom - option) < 0.05
    }
}
