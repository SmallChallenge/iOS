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
    @State private var showLogin: Bool = false

    private let container = AppDIContainer.shared

    var body: some View {
        ZStack(alignment: .bottom) {
            VStack (spacing: .zero) {
                
                HeaderView {
                    // 프로필버튼 클릭
                    showLogin = true
                }
                
                TabView (selection: $selectedTab){
                    container.makeMyLogView()
                        .tag(0)
                    
                    EmptyView()
                        .tag(1)
                    
                    container.makeCommunityView()
                        .tag(2)
                } //~TabView
                .hideTabBar()
                
               
            } // ~ VStack
            
            // 커스텀 탭바 [내 기록 | 촬영버튼 | 커뮤니티]
            MainTabBar(selectedTab: $selectedTab, showCamera: $showCamera)
            
        } // ~ZStack
        .mainBackgourndColor()
        .fullScreenCover(isPresented: $showCamera) {
            // 카메라 촬영화면 띄우기
            container.makeCameraTapView  {
                showCamera = false
            }
        }
        .sheet(isPresented: $showLogin, content: {
            container.makeLoginView()
        })
        .onAppear {
            // 카메라 권한 받기
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
