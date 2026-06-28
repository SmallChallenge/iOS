//
//  CameraTabView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CameraTabView: View {
    /// 뒤로가기 액션 클로저 (Environment 대신 클로저로 성능 최적화)
    let diContainer: CameraDIContainerProtocol
    let onDismiss: () -> Void

    @State var selectedTab: CameraViewTab = .camera

    // 에디터 네비게이션 상태
    @State private var navigateToEditor = false
    @State private var selectedImage: UIImage?
    @State private var capturedDate: Date?

    // 카메라 탭
    enum CameraViewTab: String, CaseIterable, Identifiable {
        case gallery = "갤러리"
        case camera = "카메라"
        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HeaderView(leadingView: {
                    // 뒤로가기 버튼
                    BackButton {
                        onDismiss()
                    }
                })

                if selectedTab == .camera { // 카메라 화면
                    diContainer.makeCameraView(
                        onCaptured: { image in
                            selectedImage = image
                            capturedDate = Date() // 촬영시간(지금)
                            navigateToEditor = true
                        }
                    )

                } else { // 갤러리 화면
                    diContainer.makeGalleryView(
                        onImageSelected: { image, date in
                            selectedImage = image
                            capturedDate = date
                            navigateToEditor = true
                        }
                    )
                }

                //갤러리, 카메라 버튼
                HStack(spacing: .zero) {
                    ForEach(CameraViewTab.allCases) { tab in
                        CameraTabButton(
                            title: tab.rawValue,
                            isSelected: selectedTab == tab
                        ) {
                            selectedTab = tab
                        }
                    }
                }
            } // ~VStack
            .mainBackgourndColor()
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $navigateToEditor) {
                if let image = selectedImage {
                    diContainer.makeEditorView(
                        capturedImage: image,
                        capturedDate: capturedDate ?? Date(), // 촬영시간 못가져왔으면, 지금.
                        onGoBack: { navigateToEditor = false },
                        onComplete: onDismiss
                    )
                }
            }
        } //~ NavigationStack
        .onAppear {
            // 세로 방향으로 고정
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            // 화면을 나갈 때 방향 제한 해제
            AppDelegate.orientationLock = .all
        }
    }
}

#Preview {
    AppDIContainer.shared.makeCameraTapView(onDismiss: {})
}



