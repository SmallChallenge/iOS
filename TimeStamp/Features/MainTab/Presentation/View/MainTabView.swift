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
    @State private var presentMypage: Bool = false
    
    private let container = AppDIContainer.shared
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack (spacing: .zero) {
                    
                    HeaderView {
                        // 프로필버튼 클릭
                        presentMypage = true
                    }
                    
                    // content화면 (내기록 | 커뮤니티)
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
                
                // 마이페이지 이동
                NavigationLink(
                    destination: AppDIContainer.shared.makeMyPageView(),
                    isActive: $presentMypage) {
                    EmptyView()
                }
                
            } // ~ZStack
            .mainBackgourndColor()
            .navigationBarHidden(true) // 기본 navigation bar 숨김
            
        } // ~NavigationView
        .fullScreenCover(isPresented: $showCamera) {
            // 카메라 촬영화면 띄우기
            container.makeCameraTapView  {
                showCamera = false
            }
        }
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
