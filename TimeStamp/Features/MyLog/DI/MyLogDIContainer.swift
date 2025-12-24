//
//  MyLogDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation

final class MyLogDIContainer {

    // MARK: - Dependencies

    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    // MARK: - Initializer

    init(localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    // MARK: - Repository

    private func makeMyLogRepository() -> MyLogRepositoryProtocol {
        return MyLogRepository(localDataSource: localDataSource)
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
