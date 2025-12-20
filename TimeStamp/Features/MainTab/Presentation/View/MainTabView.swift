//
//  MainView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation
import SwiftUI
import AVFoundation

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var showCamera: Bool = false

    private let container = AppDIContainer.shared

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView (selection: $selectedTab){
                container.makeMyLogView()
                    .tag(0)

                EmptyView()
                    .tag(1)

                container.makeCommunityView()
                    .tag(2)
            } //~TabView
            .hideTabBar()

            MainTabBar(selectedTab: $selectedTab, showCamera: $showCamera)

        } // ~ZStack
        .fullScreenCover(isPresented: $showCamera) {
            container.makeCameraTapView  {
                showCamera = false
            }
        }
        .onAppear {
            requestCameraPermission()
        }
    }

    /// 앱 시작 시 카메라 권한 요청
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("✅ 카메라 권한 허용됨")
            } else {
                print("❌ 카메라 권한 거부됨")
            }
        }
    }
}

#Preview {
    MainTabView()
}
