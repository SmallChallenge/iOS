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
