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


    @State private var showLimitReachedPopup: Bool = false
    @State private var showLoginView: Bool = false

    private let container: AppDIContainer
    @StateObject private var viewModel: MainTabViewModel

    init(container: AppDIContainer, viewModel: MainTabViewModel) {
        self.container = container
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            if !presentMypage {
                VStack (spacing: .zero) {

                    HeaderView(selectedTab: $selectedTab) {
                        // 프로필버튼 클릭
                        presentMypage = true
                    }

                    // content화면 (내기록 | 커뮤니티)
                    TabView (selection: $selectedTab){
                        NavigationStack {
                            container.makeMyLogView()
                        }
                        .tag(0)

                        EmptyView()
                            .tag(1)

                        NavigationStack {
                            container.makeCommunityView()
                        }
                        .tag(2)

                    } //~TabView
                    .hideTabBar()

                    // 커스텀 탭바 [내 기록 | 촬영버튼 | 커뮤니티]
                    MainTabBar(selectedTab: $selectedTab, onCameraButtonTapped: {
                        // 로컬기록이 20개 이상이면 팝업 띄우기
                        if viewModel.canTakePhoto() {
                            showCamera = true
                        } else {
                            showLimitReachedPopup = true
                            }
                        })

                } // ~ VStack
                .mainBackgourndColor()
                .transition(.move(edge: .leading))
            }

            if presentMypage {
                NavigationStack {
                    container.makeMyPageView(onGoBack: {
                        presentMypage = false
                    })
                }
                .transition(.move(edge: .trailing))
            }
        } // ~ZStack
        .animation(.default, value: presentMypage)
        .popup(isPresented: $showLimitReachedPopup, content: {
            Modal(title: "기록 한계에 도달했어요.\n로그인하면 계속 기록할 수 있어요.")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        showLimitReachedPopup = false
                    }
                    MainButton(title: "로그인") {
                        showLoginView = true
                        showLimitReachedPopup = false
                    }
                }
        })
        // 카메라 촬영화면 띄우기
        .fullScreenCover(isPresented: $showCamera) {
            container.makeCameraTapView  {
                showCamera = false
            }
        }
        // 로그인 화면 띄우기
        .fullScreenCover(isPresented: $showLoginView) {
            container.makeLoginView {
                showLoginView = false
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
                Logger.success("카메라 권한 허용됨")
            } else {
                Logger.warning("카메라 권한 거부됨")
            }
        }
    }
}

#Preview {
    let container = AppDIContainer.shared
    let localDataSource = LocalTimeStampLogDataSource()
    let repository = MyLogRepository(localDataSource: localDataSource, apiClient: MyLogApiClient(session: SessionFactory().makeSession(for: .dev)))
    let useCase = MyLogUseCase(repository: repository)
    let viewModel = MainTabViewModel(myLogUseCase: useCase)
    return MainTabView(container: container, viewModel: viewModel)
}
