//
//  LaunchScreenView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject private var viewModel: LaunchScreenViewModel
    @State private var opacity = 0.0
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
                Color.gray900
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // 로고나 앱 이름
                    Text("Stampy")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundStyle(.white)

                    // 태그라인이나 서브 텍스트
                    Text("당신의 순간을 기록하다")
                        .font(.body)
                        .foregroundStyle(.gray300)
                }
                .opacity(opacity)
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
