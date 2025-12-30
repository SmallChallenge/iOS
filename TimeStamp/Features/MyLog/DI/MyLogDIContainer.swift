//
//  MyLogDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation
import Alamofire

protocol MyLogDIContainerProtocol {
    func makeMyLogView() -> MyLogView
    func makeLogDetailView(log: TimeStampLogViewData, onGoBack: @escaping () -> Void) -> LogDetailView

}
struct MyLogDIContainer: MyLogDIContainerProtocol {

    // MARK: - Dependencies

    private let localDataSource: LocalTimeStampLogDataSourceProtocol
    private let session: Session

    // MARK: - Initializer

    init(session: Session, localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.session = session
        self.localDataSource = localDataSource
    }
    
    // MARK: - MyLog
    private func makeMyLogApiClient() -> MyLogApiClientProtocol {
        return MyLogApiClient(session: session)
    }

    private func makeMyLogRepository() -> MyLogRepositoryProtocol {
        let apiClient = makeMyLogApiClient()
        return MyLogRepository(localDataSource: localDataSource, apiClient: apiClient)
    }

    private func makeMyLogUseCase() -> MyLogUseCaseProtocol {
        return MyLogUseCase(repository: makeMyLogRepository())
    }

    private func makeMyLogViewModel() -> MyLogViewModel {
        return MyLogViewModel(useCase: makeMyLogUseCase())
    }

    func makeMyLogView() -> MyLogView {
        let viewModel = makeMyLogViewModel()
        return MyLogView(viewModel: viewModel, diContainer: self)
    }
    
    private func makeLogDetailViewModel(log: TimeStampLogViewData) -> LogDetailViewModel {
        return LogDetailViewModel(log: log)
    }

    // MARK: - LogDetailView
    func makeLogDetailView(log: TimeStampLogViewData, onGoBack: @escaping () -> Void) -> LogDetailView {
        let viewModel = makeLogDetailViewModel(log: log)
        return LogDetailView(
            viewModel: viewModel,
            onGoBack: onGoBack
        )
    }
}

// MARK: --------------------------------- Mock --------------------------------
struct MockMyLogDIContainer: MyLogDIContainerProtocol {
   
    func makeMyLogView() -> MyLogView {
        let usecase = MockMyLogUseCase()
        let viewModel = MyLogViewModel(useCase: usecase)
        return MyLogView(viewModel: viewModel, diContainer: self)
    }
    
    struct MockMyLogUseCase: MyLogUseCaseProtocol {
        func fetchAllLogs(isLoggedIn: Bool) async -> (logs: [TimeStampLog], pageInfo: PageInfo?) {
            ([], nil)
        }
        func fetchServerLogs(page: Int) async -> (logs: [TimeStampLog], pageInfo: PageInfo?) {
            ([], nil)
        }   
    }
    
    // MARK: - LogDetailView
    func makeLogDetailView(log: TimeStampLogViewData, onGoBack: @escaping () -> Void) -> LogDetailView {
        let viewModel = LogDetailViewModel(log: log)
        return LogDetailView(
            viewModel: viewModel,
            onGoBack: onGoBack
        )
    }
}
