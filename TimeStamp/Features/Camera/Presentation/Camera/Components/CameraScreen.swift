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
    
    @State private var zoomAtGestureStart: CGFloat = 1.0

    init(camera: CameraManager, aspectRatio: Binding<CameraAspectRatio>) {
        self.cameraManager = camera
        self._aspectRatio = aspectRatio
    }

    var body: some View {
        CameraPreviewView(session: cameraManager.session)
            .aspectRatio(3/4, contentMode: .fit)
            .overlay { // 선택한 비율로 영역을 제한
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
            .pinchZoom(currentZoom: cameraManager.displayZoom) { zoom in
                cameraManager.setDisplayZoom(zoom)
            }
            .overlay(alignment: .bottom, content: {
                // 렌즈 전환 버튼 (줌 버튼)
                zoomButtons
            })
            .overlay(alignment: .trailing) { // 비율 버튼
                Button {
                    aspectRatio.toggle()
                } label: {
                    ZStack(alignment: .center) {
                        Capsule()
                            .frame(width: 72, height: 36, alignment: .center)
                            .foregroundStyle(Color.black.opacity(0.5))
                        
                        HStack (alignment: .center, spacing: 6){
                            Image("square_focus")
                                .frame(width: 20, height: 20)
                            
                            Text(aspectRatio.toggled.title)
                                .font(.pretendard(.medium), size: 14)
                                .foregroundStyle(.gray50)
                                .frame(width: 22, alignment: .center) // 폭 고정
                        }
                    }
                    .animation(nil, value: aspectRatio)
                    .padding(.trailing, 18)
                    
                }
            }
            .animation(.easeInOut(duration: 0.2), value: aspectRatio)
    }
    
    private var zoomButtons: some View {
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
    
    // MARK: - methods..
    private func Zoomlabel(for value: CGFloat) -> String {
        value == value.rounded() ? "\(Int(value))x" : String(format: "%.1fx", value)
    }

    private func isSelected(zoom option: CGFloat) -> Bool {
        abs(cameraManager.displayZoom - option) < 0.05
    }
}
