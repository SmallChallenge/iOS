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
    @State private var selectedLog: TimeStampLogViewData? = nil

    @State private var showLimitReachedPopup: Bool = false
    @State private var showLoginView: Bool = false

    @State private var triggerCommunityRefresh: Bool = false
    
    private let container: AppDIContainer
    @StateObject private var viewModel: MainTabViewModel
    
    init(container: AppDIContainer, viewModel: MainTabViewModel) {
        self.container = container
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack (spacing: .zero) {
                // 커스텀 헤더
                MainHeader(selectedTab: $selectedTab) {
                        presentMypage = true
                    }
                
                // content화면 (내기록 | 커뮤니티)
                TabView (selection: $selectedTab){
                    
                    // 내기록
                    container.makeMyLogView(selectedLog: $selectedLog)
                        .tag(0)
                    
                    EmptyView()
                        .tag(1)
                    
                    // 커뮤니티 화면
                    container.makeCommunityView(triggerRefresh: $triggerCommunityRefresh)
                        .tag(2)
                    
                } //~TabView
                .hideTabBar()
                
                // 커스텀 탭바 [내 기록 | 촬영버튼 | 커뮤니티]
                MainTabBar(
                    selectedTab: $selectedTab,
                    onCameraButtonTapped: {
                        // 로컬기록이 20개 이상이면 팝업 띄우기
                        if viewModel.canTakePhoto() {
                            showCamera = true
                        } else {
                            showLimitReachedPopup = true
                        }
                    },
                    onCommunityReselected: {
                        // 커뮤니티 탭 재선택 시 새로고침 트리거
                        triggerCommunityRefresh = true
                    }
                )
                
            } // ~ VStack
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .mainBackgourndColor()
            .task {
                // 추적 권한 요청
                await viewModel.requestAuthorization()
            }
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
            .onReceive(NotificationCenter.default.publisher(for: .shouldRefreshMyLog)) { _ in
                // 사진 저장 후 탭바 '내기록'으로 이동
                selectedTab = 0
            }
            // 마이페이지 화면으로
            .navigationDestination(isPresented: $presentMypage) {
                container.makeMyPageView(onGoBack: {
                    presentMypage = false
                })
            }
            // 기록 상세보기 화면으로
            .navigationDestination(isPresented: Binding(
                get: { selectedLog != nil },
                set: { if !$0 { selectedLog = nil } }
            )) {
                if let log = selectedLog {
                    container.makeLogDetailView(log: log) {
                        selectedLog = nil
                    }
                }
            }
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
        } // ~NavigationStack
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
