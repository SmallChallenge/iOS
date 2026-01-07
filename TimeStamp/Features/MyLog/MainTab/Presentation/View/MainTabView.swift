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
    
    private let container: AppDIContainer
    @StateObject private var viewModel: MainTabViewModel
    
    init(container: AppDIContainer, viewModel: MainTabViewModel) {
        self.container = container
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack (spacing: .zero) {
                
                // content화면 (내기록 | 커뮤니티)
                TabView (selection: $selectedTab){
                    container.makeMyLogView(selectedLog: $selectedLog)
                        .tag(0)
                    
                    EmptyView()
                        .tag(1)
                    
                    container.makeCommunityView()
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
            .task {
                // 추적 권한 요청
                let isAuthorized = await TrackingManager.shared.requestTrackingAuthorization()

                if isAuthorized {
                    Logger.success("추적 권한 허용됨 - 분석 도구 활성화")
                } else {
                    Logger.info("추적 권한 거부됨 - 제한된 분석 모드")
                }

                // 추적 권한 상태가 결정된 후 Amplitude 초기화
                AmplitudeManager.shared.loadAmplitude()
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
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    logoInHeader
                }
                
                // 프로필 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    profillButtonInHeader
                }
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
    private var logoInHeader: some View {
        Group {
            if selectedTab == 0 {
                Image("Logotype")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(Color.gray50)
                    .frame(width: 122.8, height: 26)
                    .padding(.vertical, 17)
                
            } else {
                Text("커뮤니티")
                    .font(.H2)
                    .foregroundStyle(Color.gray50)
            }
        }
    }
    
    private var profillButtonInHeader: some View {
        Button {
            presentMypage = true
        } label: {
            Image("iconUser_line")
                .resizable()
                .frame(width: 24, height: 24)
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
