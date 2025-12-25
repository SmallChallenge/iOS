//
//  MyLogDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation
import Alamofire


struct MyLogDIContainer {

    // MARK: - Dependencies

    private let localDataSource: LocalTimeStampLogDataSourceProtocol
    private let session: Session

    // MARK: - Initializer

    init(session: Session, localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.session = session
        self.localDataSource = localDataSource
    }
    
    // MARK: - ApiClient
    private func makeMyLogApiClient() -> MyLogApiClientProtocol {
        return MyLogApiClient(session: session)
    }

    // MARK: - Repository

    private func makeMyLogRepository() -> MyLogRepositoryProtocol {
        let apiClient = makeMyLogApiClient()
        return MyLogRepository(localDataSource: localDataSource, apiClient: apiClient)
    }

    // MARK: - UseCase

    private func makeMyLogUseCase() -> MyLogUseCaseProtocol {
        return MyLogUseCase(repository: makeMyLogRepository())
    }

    // MARK: - ViewModel

    private func makeMyLogViewModel() -> MyLogViewModel {
        return MyLogViewModel(useCase: makeMyLogUseCase())
    }

    // MARK: - View

    func makeMyLogView() -> MyLogView {
        let viewModel = makeMyLogViewModel()
        return MyLogView(viewModel: viewModel)
    }
}

// MARK: - Mock
struct MockMyLogDIContainer {
    private func makeMyLogUseCase() -> MyLogUseCaseProtocol {
        return MockMyLogUseCase()
    }
    private func makeMyLogViewModel() -> MyLogViewModel {
        return MyLogViewModel(useCase: makeMyLogUseCase())
    }
    func makeMyLogView() -> MyLogView {
        let viewModel = makeMyLogViewModel()
        return MyLogView(viewModel: viewModel)
    }
    
    struct MockMyLogUseCase: MyLogUseCaseProtocol {
        func fetchAllLogs(isLoggedIn: Bool) async -> [TimeStampLog] {
            []
        }
    }
}
