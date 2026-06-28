//
//  LaunchScreenDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

final class LaunchScreenDIContainer {

    // MARK: - Dependencies

    private let authApiClient: AuthApiClientProtocol
    private let appContainer: AppDIContainer

    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol, appContainer: AppDIContainer) {
        self.authApiClient = authApiClient
        self.appContainer = appContainer
    }

    // MARK: - Repository

    private func makeLaunchScreenRepository() -> LaunchScreenRepositoryProtocol {
        return LaunchScreenRepository(authApiClient: authApiClient)
    }

    // MARK: - View

    func makeLaunchScreenView() -> LaunchScreenView {
        let repository = makeLaunchScreenRepository()
        let useCase = LaunchScreenUseCase(repository: repository)
        let viewModel = LaunchScreenViewModel(useCase: useCase)

        // Delegate 설정 (UseCase → ViewModel)
        useCase.delegate = viewModel

        return LaunchScreenView(viewModel: viewModel, container: appContainer)
    }
}
