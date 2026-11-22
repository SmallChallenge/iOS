//
//  CameraView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI
import AVFoundation


/// 사진 촬영 화면(탭뷰)에서 카메라 화면
struct CameraView: View {
    @StateObject private var viewModel: CameraViewModel
    let onCaptured: (UIImage) -> Void

    // MARK: - Private property

    /// 첫 진입인지 확인
    @State private var isFirstAppear: Bool = true
    
    
    @State private var zoomAtGestureStart: CGFloat = 1.0
    @AppStorage("cameraAspectRatio") private var aspectRatio: CameraAspectRatio = .threeFour

    // MARK: - Initialization

    init(
        makeViewModel: @autoclosure @escaping () -> CameraViewModel,
        onCaptured: @escaping (UIImage) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: makeViewModel())
        self.onCaptured = onCaptured
    }
    
    // MARK: - body

    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: .zero) {
            
                Spacer()

                // 카메라 프리뷰 + 줌버튼 + 오버레이
                ZStack(alignment: .center) {
                    // 카메라 프리뷰
                    #if targetEnvironment(simulator)
                    Color.gray
                        
                    #else
                    // 카메라 프리뷰: 선택한 비율로 영역을 제한
                    CameraScreen(aspectRatio: $aspectRatio,
                                 session: viewModel.cameraManager.session)
                    .pinchZoom(currentZoom: viewModel.cameraManager.displayZoom) { zoom in
                        viewModel.cameraManager.setDisplayZoom(zoom)
                    }
                    
                    #endif

                    // 오버레이 뷰 (타임스탬프, 로고) - 매분 정각에 자동 업데이트
                    TimelineView(.everyMinute) { context in
                        viewModel.selectedTemplate.makeView(displayDate: context.date, hasLogo: true)
                    }
                    .aspectRatio(aspectRatio.value, contentMode: .fit)
                }
                .overlay(alignment: .bottom, content: {
                    // 렌즈 전환 버튼 (줌 버튼)
                    zoomButtons
                })
                .overlay(alignment: .leading) { // 비율 버튼
                    Button {
                        aspectRatio.toggle()
                    } label: {
                        Text(aspectRatio == .threeFour ? "1:1" : "3:4")
                            .font(.Caption)
                            .foregroundStyle(.white)
                            .frame(width: 30, height: aspectRatio == .threeFour ? 30 : 40)
                            .border(.white)
                            .padding(6)
                    }
                }
                //.aspectRatio(CameraAspectRatio.threeFour.value , contentMode: .fit)

                .animation(.easeInOut(duration: 0.2), value: aspectRatio)
                
                // 컨트롤러: 카메라전환, 촬영버튼, 플래시
                Spacer()
                controller
                Spacer()
                
            } // ~VStack
            .task {
                viewModel.loadLastSelectedTemplate()
            }
            .onAppear {
                viewModel.onAppear()
                viewModel.cameraManager.captureAspectRatio = aspectRatio
                zoomAtGestureStart = 1.0
            }
            .onDisappear {
                viewModel.onDisappear()
            }
            .onChange(of: aspectRatio) { newValue in
                viewModel.cameraManager.captureAspectRatio = newValue
            }
        } // ~Zstack
        .background(VolumeButtonCapture { viewModel.capturePhoto() })
        .onAppear {
            guard isFirstAppear else { return }
            isFirstAppear = false
            AmplitudeManager.shared.trackCameraViewEnter()
        }
        .onChange(of: viewModel.capturedImage) { newImage in
            if let image = newImage {
                onCaptured(image)
            }
        }
        .alert("카메라 권한 필요", isPresented: $viewModel.showPermissionAlert) {
            Button("확인", role: .cancel) { }
            Button("설정으로 이동") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("카메라를 사용하려면 설정에서 권한을 허용해주세요.")
        }
    }
    
    // MARK: - Controller

    /// 카메라 전환, 촬영, 플래시 버튼
    var controller: some View {
        HStack (alignment: .center, spacing: 48){
            // 카메라 전환 버튼 (전면 ↔ 후면)
            Button {
                viewModel.switchCamera()
            } label: {
                Image("IconCamera_Rotate")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray300)
                    .frame(width: 24, height: 24)
                    .padding(10)
            }

            // 촬영 버튼
            Button {
                viewModel.capturePhoto()
            } label: {
                Circle()
                    .stroke(lineWidth: 5)
                    .foregroundStyle(.gray50)
                    .frame(width: 80, height: 80)
            }
            .disabled(viewModel.isCapturing)


            // 플래시 버튼 (off -> auto -> on)
            Button {
                viewModel.toggleFlash()
            } label: {
                flashIcon
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray50)
                    .frame(width: 24, height: 24)
                    .padding(10)
            }

        }
    }
    
    private var zoomButtons: some View {
        HStack(spacing: 12) {
            ForEach(viewModel.cameraManager.lensOptions, id: \.self) { option in
                Button {
                    viewModel.cameraManager.setDisplayZoom(option, animated: true)
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

    // MARK: - Flash UI

    /// 플래시 모드에 따른 아이콘
    private var flashIcon: Image {
        switch viewModel.flashMode {
        case .off:
            return Image("IconFlash_Line")       // 플래시 끔
        case .auto:
            return Image("IconFlash_Auto")       // 자동 플래시
        case .on:
            return Image("IconFlash_Fill")      // 항상 켜짐
        }
    }
    
    // MARK: - methods..
    private func Zoomlabel(for value: CGFloat) -> String {
        value == value.rounded() ? "\(Int(value))x" : String(format: "%.1fx", value)
    }

    private func isSelected(zoom option: CGFloat) -> Bool {
        abs(viewModel.cameraManager.displayZoom - option) < 0.05
    }
}

#Preview {
    CameraView(
        makeViewModel: CameraViewModel(cameraManager: CameraManager()), onCaptured: { _ in}
    )
    .background(Color.black)
}
