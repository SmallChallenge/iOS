//
//  LaunchScreenView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject private var viewModel: LaunchScreenViewModel
    private let container: AppDIContainer

    init(viewModel: LaunchScreenViewModel, container: AppDIContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
    }

    var body: some View {
        if viewModel.shouldNavigate {
            // 로딩 완료 후 메인 화면으로 전환
            let selectedTab = viewModel.shouldLaunchCameraOnStart ? 1 : 0 
            container.makeMainTabView(selectedTab: selectedTab)
            
        } else {
            ZStack {
                Color.launch
                    .ignoresSafeArea()

                Image("LaunchImage")

            }
            .task {
                viewModel.getLaunchCameraOnStart()
                // 토큰 갱신 + 유저 정보 가져오기
                viewModel.checkAuth()
            }
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
