//
//  CommunityDiContainer.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import Foundation
import SwiftUI

protocol CommunityDiContainerProtocol {
    func makeCommunityView(triggerRefresh: Binding<Bool>) -> CommunityView
}

final class CommunityDiContainer: CommunityDiContainerProtocol {

    // MARK: - Dependencies

    private let communityApiClient: CommunityApiClientProtocol

    // MARK: - Initializer

    init(communityApiClient: CommunityApiClientProtocol) {
        self.communityApiClient = communityApiClient
    }

    // MARK: - Repository

    private func makeCommunityRepository() -> CommunityRepositoryProtocol {
        return CommunityRepository(apiClient: communityApiClient)
    }

    // MARK: - UseCase

    private func makeCommunityUseCase() -> CommunityUseCaseProtocol {
        return CommunityUseCase(repository: makeCommunityRepository())
    }

    // MARK: - ViewModel

    private func makeCommunityViewModel() -> CommunityViewModel {
        return CommunityViewModel(useCase: makeCommunityUseCase())
    }

    // MARK: - View

    func makeCommunityView(triggerRefresh: Binding<Bool> = .constant(false)) -> CommunityView {
        let viewModel = makeCommunityViewModel()
        return CommunityView(viewModel: viewModel, triggerRefresh: triggerRefresh)
    }
}

//MARK: - MOCK
struct MockCommunityDiContainer: CommunityDiContainerProtocol {
    func makeCommunityView(triggerRefresh: Binding<Bool> = .constant(false)) -> CommunityView {
        let usecase = MockCommunityUseCase()
        let vm = CommunityViewModel(useCase: usecase)
        return CommunityView(viewModel: vm, triggerRefresh: triggerRefresh)
    }
}

struct MockCommunityUseCase: CommunityUseCaseProtocol {
    func feeds(category: String?, lastPublishedAt: String?, lastImageId: Int?) async throws -> CommunityListInfo {
        CommunityListInfo(
            feeds: [],
            sliceInfo: .init(nextCursorId: 0, nextCursorPublishedAt: "", hasNext: false, size: 0)
            )
    }
    func report(imageId: Int) async throws {}
    func cancelReport(imageId: Int) async throws {}
    func block(nickname: String) async throws {}
    func like(imageId: Int) async throws {}
}
