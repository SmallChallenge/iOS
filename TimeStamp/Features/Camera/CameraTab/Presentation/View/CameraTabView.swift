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

    // 카메라 탭
    enum CameraViewTab: String, CaseIterable, Identifiable {
        case gallery = "갤러리"
        case camera = "카메라"
        var id: String { self.rawValue }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {

                if selectedTab == .camera {

                    // 카메라 화면
                    diContainer.makeCameraView(onDismiss: onDismiss)

                } else {

                    // 갤러리 화면
                    diContainer.makeGalleryView(onDismiss: onDismiss)
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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    // 뒤로가기 버튼
                    BackButton {
                        onDismiss()
                    }
                }
            }
        } //~ NavigationView
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



