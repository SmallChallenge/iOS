//
//  MyLogDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation

final class MyLogDIContainer {

    // MARK: - Dependencies

    private let localRepository: LocalTimeStampLogRepositoryProtocol

    // MARK: - Initializer

    init(localRepository: LocalTimeStampLogRepositoryProtocol) {
        self.localRepository = localRepository
    }

    // MARK: - Repository

    private func makeMyLogRepository() -> MyLogRepositoryProtocol {
        return MyLogRepository(localRepository: localRepository)
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
