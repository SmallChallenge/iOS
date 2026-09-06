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
            ZStack {
                Color.yellow
                    .ignoresSafeArea()
                Image("LaunchImage")
            }
            .popup(isPresented: $viewModel.showVersionUpdatePopup, content: {
                Modal(title: "업데이트가 필요합니다")
                    .buttons {
                        MainButton(title: "업데이트 하기") {
                            openAppStore()
                        }
                    }
            })
            .task {
                // 1단계: 유저 확인
                let _ = await viewModel.checkAuth()

                // 2단계: 버전 확인
                await viewModel.checkVersion()

                // 버전 업데이트가 필요하지 않으면 진행
                if !viewModel.showVersionUpdatePopup {
                    // 3단계: 카메라 여부 확인
                    viewModel.getLaunchCameraOnStart()

                    // 모든 단계 완료 → 메인 화면으로 이동
                    viewModel.shouldNavigate = true
                }
            }
        }
    }
    
    // MARK: - functions
    
    private func openAppStore() {
        if let appStoreURL = URL(string: "https://apps.apple.com/app/id6756785730") {
            openURL(appStoreURL)
        }
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
