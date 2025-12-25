//
//  MyLogViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation
import Combine

@MainActor
final class MyLogViewModel: ObservableObject, MessageDisplayable {

    // MARK: - Properties

    /// MyLog UseCase
    private let useCase: MyLogUseCaseProtocol

    // MARK: - Output Properties

    @Published var isLoading = false
    
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    /// 전체 로그 (필터링은 View에서 수행)
    @Published var myLogs: [TimeStampLogViewData] = []

    /// 사진이 있는 카테고리만 필터링    
    var availableCategories: [CategoryFilterViewData] {
        let categorySet = Set(myLogs.map { $0.category })

        return [.all] + CategoryFilterViewData.allCases.filter { category in
            switch category {
            case .all: return false // 이미 추가됨
            case .study: return categorySet.contains(.study)
            case .health: return categorySet.contains(.health)
            case .food: return categorySet.contains(.food)
            case .etc: return categorySet.contains(.etc)
            }
        }
    }

    // MARK: - Init

    init(useCase: MyLogUseCaseProtocol) {
        self.useCase = useCase
        loadLogs()
    }

    // MARK: - Methods

    /// 모든 로그를 불러오기
    func loadLogs() {
        isLoading = true
        Task {
            do {
                let entities = try await useCase.fetchAllLogs()
                myLogs = entities.map { toViewData($0) }
                isLoading = false
                Logger.success("로그 불러오기 성공: \(myLogs.count)개")
            } catch {
                isLoading = false
                show(.unknownRequestFailed)
                Logger.error("로그 불러오기 실패: \(error)")
            }
        }
    }

    // MARK: - Private Helpers

    /// Entity를 ViewData로 변환
    private func toViewData(_ entity: TimeStampLog) -> TimeStampLogViewData {
        return TimeStampLogViewData(
            id: entity.id,
            category: entity.category,
            timeStamp: entity.timeStamp,
            imageSource: entity.imageSource,
            visibility: entity.visibility
        )
    }
}
