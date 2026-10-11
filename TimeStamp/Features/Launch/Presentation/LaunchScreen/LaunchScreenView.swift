//
//  LaunchScreenView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @Environment(\.openURL) var openURL
    @StateObject private var viewModel: LaunchScreenViewModel
    private let container: AppDIContainer

    init(viewModel: LaunchScreenViewModel, container: AppDIContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
    }

    var body: some View {
        if viewModel.shouldNavigate {
            let selectedTab = viewModel.shouldLaunchCameraOnStart ? 1 : 0
            container.makeMainTabView(selectedTab: selectedTab)
        } else {
            
            // 스플래시 화면
            ZStack {
                Color.launch
                    .ignoresSafeArea()
                Image("LaunchImage")
            }
            // 필수 업데이트 안내
            .popup(isPresented: $viewModel.showVersionRequiredUpdatePopupMessage, content: {
                Modal(title: "원활한 서비스 이용을 위해 최신 버전으로 업데이트해 주세요.")
                    .buttons {
                        MainButton(title: "업데이트 하기") {
                            openAppStore()
                        }
                    }
            })
            // 권장 업데이트 안내
            .popup(isPresented: $viewModel.showVersionOptionalUpdatePopupMessage, content: {
                Modal(title: "새로운 기능이 추가되었어요.\n지금 업데이트하고 더 새로워진 스탬픽을 만나보세요.")
                    .buttons {
                        MainButton(title: "업데이트 하기") {
                            openAppStore()
                        }
                        MainButton(title: "나중에", colorType: .secondary) {
                            // 안띄우기 기간 업데이트
                            viewModel.saveRecommendedUpdateDismissal()
                            viewModel.showVersionOptionalUpdatePopupMessage = false
                            
                            // 카메라 여부 확인 및 메인 화면으로 이동
                            completeSplash()
                        }
                    }
            })
            .task {
                // 1단계: 유저 확인
                let _ = await viewModel.checkAuth()

                // 2단계: 버전 확인
                await viewModel.checkVersion()

                // 버전 업데이트 확인
                if (viewModel.showVersionRequiredUpdatePopupMessage || viewModel.showVersionOptionalUpdatePopupMessage ) {
                    // 팝업띄우러 나가
                    return
                }
                // 카메라 시작 여부 확인 및 메인 화면으로 이동
                completeSplash()
            }
        }
    }
    
    // MARK: - functions
    
    private func openAppStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/id6756785730") {
            openURL(appStoreURL)
        }
    }
    
    
    func completeSplash() {
        // 3단계: 카메라 시작 여부 확인
        viewModel.getLaunchCameraOnStart()

        // 모든 단계 완료 → 메인 화면으로 이동
        viewModel.shouldNavigate = true
    }

}

#Preview {
    let repository = LaunchRepository(authApiClient: AuthApiClient(session: SessionFactory().makeSession(for: .dev)))
    let useCase = LaunchScreenUseCase(repository: repository)
    let viewModel = LaunchScreenViewModel(useCase: useCase)
    LaunchScreenView(
        viewModel: viewModel,
        container: AppDIContainer.shared
    )
}
