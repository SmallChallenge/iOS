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

    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
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

        return LaunchScreenView(viewModel: viewModel)
    }
}
