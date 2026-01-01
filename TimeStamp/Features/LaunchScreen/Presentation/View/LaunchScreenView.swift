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
            container.makeMainTabView()
            
        } else {
            ZStack {
                Color.launch
                    .ignoresSafeArea()

                Image("LaunchImage")

            }
            .onAppear {
                // 토큰 갱신 체크
                viewModel.checkAuth()
            }
        }
    }
}

#Preview {
    let repository = LaunchScreenRepository(authApiClient: AuthApiClient(session: SessionFactory().makeSession(for: .dev)))
    let useCase = LaunchScreenUseCase(repository: repository)
    let viewModel = LaunchScreenViewModel(useCase: useCase)
    LaunchScreenView(
        viewModel: viewModel,
        container: AppDIContainer.shared
    )
}
