//
//  CameraView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI

/// 사진 촬영 화면(탭뷰)에서 카메라 화면
struct CameraView: View {
    @StateObject var viewModel: CameraViewModel
    let diContainer: CameraDIContainerProtocol
    let onDismiss: () -> Void

    // MARK: - Private property

    // 다음화면으로 (에디터)
    @State private var navigateToEditor = false

    // MARK: - Initialization

    init(
        viewModel: CameraViewModel,
        diContainer: CameraDIContainerProtocol,
        onDismiss: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
        self.diContainer = diContainer
    }
    
    // MARK: - body

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // 카메라 프리뷰 + 오버레이
                ZStack {
                    // 카메라 프리뷰
                    #if targetEnvironment(simulator)
                    Color.gray
                    #else
                    CameraPreviewView(session: viewModel.cameraManager.session)
                    #endif

                    // 오버레이 뷰 (타임스탬프, 로고) - 매분 정각에 자동 업데이트
                    TimelineView(.everyMinute) { context in
                        DefaultTemplateView(displayDate: context.date, hasLogo: true)
                    }
                }
                .aspectRatio(1, contentMode: .fit)
                .padding(.top, 40)


                Spacer()
                controller
                Spacer()
            } // ~VStack
            .onAppear {
                viewModel.onAppear()
            }
            .onDisappear {
                viewModel.onDisappear()
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
            .onChange(of: viewModel.capturedImage) { newImage in
                if newImage != nil {
                    navigateToEditor = true
                }
            }

            // NavigationLink (hidden)
            if let image = viewModel.capturedImage {
                NavigationLink(
                    destination:
                    diContainer.makeEditorView(
                        capturedImage: image,
                        onGoBack: { navigateToEditor = false },
                        onDismiss:  onDismiss
                    ),
                    isActive: $navigateToEditor
                ) {
                    EmptyView()
                }
            }
        } // ~Zstack
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
}

#Preview {
    
    CameraView(
        viewModel: CameraViewModel(),
        diContainer: MockCameraDIContainer(),
        onDismiss: {}
    )
    .background(Color.black)
}
