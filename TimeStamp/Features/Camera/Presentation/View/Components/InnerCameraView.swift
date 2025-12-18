//
//  InnerCameraView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI

struct InnerCameraView: View {
    @StateObject private var viewModel = CameraViewModel()

    var body: some View {
        VStack(spacing: 0)
        {
            // 카메라 프리뷰
            CameraPreviewView(session: viewModel.cameraManager.session)
                .aspectRatio(1, contentMode: .fit)
                .padding(.top, 40)


            Spacer()
            controller
            Spacer()
        }
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
    }
    
    // 카메라 전환, 촬영, 플래시 버튼
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
                print(">>>>> 플래시 버튼 클릭")
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
            return Image("IconFlash_Fill")       // 자동 플래시
        case .on:
            return Image("IconFlash_circle_line") // 항상 켜짐
        }
    }

    /// 플래시 모드에 따른 색상
    private var flashColor: Color {
        switch viewModel.flashMode {
        case .off:
            return Color.gray300                 // 회색
        case .auto:
            return .yellow                       // 노란색
        case .on:
            return .yellow                       // 노란색
        }
    }
}

#Preview {
    InnerCameraView()
        .background(Color.black)
}
