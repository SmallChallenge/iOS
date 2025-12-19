//
//  MyLogViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation
import Combine

@MainActor
final class MyLogViewModel: ObservableObject {

    // MARK: - Properties

    /// MyLog UseCase
    private let useCase: MyLogUseCaseProtocol

    // MARK: - Output Properties

    @Published var isLoading = false
    @Published var errorMessage: String?

    /// 전체 로그 (필터링은 View에서 수행)
    @Published var myLogs: [TimeStampLogViewData] = []

    /// 사진이 있는 카테고리만 필터링
    var availableCategories: [CategoryFilterViewData] {
        var categories: [CategoryFilterViewData] = [.all] // 전체는 항상 표시

        // 각 카테고리별로 사진이 있는지 확인
        if myLogs.contains(where: { $0.category == .study }) {
            categories.append(.study)
        }
        if myLogs.contains(where: { $0.category == .health }) {
            categories.append(.health)
        }
        if myLogs.contains(where: { $0.category == .food }) {
            categories.append(.food)
        }
        if myLogs.contains(where: { $0.category == .etc }) {
            categories.append(.etc)
        }

        return categories
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

        do {
            let entities = try useCase.fetchAllLogs()
            myLogs = entities.map { toViewData($0) }
            isLoading = false
            print("✅ 로그 불러오기 성공: \(myLogs.count)개")
        } catch {
            errorMessage = "로그를 불러오는데 실패했습니다: \(error.localizedDescription)"
            isLoading = false
            print("❌ 로그 불러오기 실패: \(error)")
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
