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

    /// 로컬 타임스탬프 로그 저장소
    private let repository: LocalTimeStampLogRepositoryProtocol

    // MARK: - Output Properties

    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var myLogs: [TimeStampLogViewData] = []

    // MARK: - Init

    init(repository: LocalTimeStampLogRepositoryProtocol) {
        self.repository = repository
        loadLogs()
    }

    // MARK: - Methods

    /// Core Data에서 모든 로그를 불러오기
    func loadLogs() {
        isLoading = true

        do {
            let dtos = try repository.readAll()
            myLogs = dtos.map { toViewData($0) }
            isLoading = false
            print("✅ 로그 불러오기 성공: \(myLogs.count)개")
        } catch {
            errorMessage = "로그를 불러오는데 실패했습니다: \(error.localizedDescription)"
            isLoading = false
            print("❌ 로그 불러오기 실패: \(error)")
        }
    }

    /// 카테고리별로 필터링된 로그 불러오기
    func loadLogs(category: String) {
        isLoading = true

        do {
            let dtos = try repository.readByCategory(category)
            myLogs = dtos.map { toViewData($0) }
            isLoading = false
        } catch {
            errorMessage = "로그를 불러오는데 실패했습니다: \(error.localizedDescription)"
            isLoading = false
        }
    }

    // MARK: - Private Helpers

    /// DTO를 ViewData로 변환
    private func toViewData(_ dto: LocalTimeStampLogDto) -> TimeStampLogViewData {
        // Category 문자열을 enum으로 변환
        let category: Category
        switch dto.category {
        case "공부":
            category = .study
        case "운동":
            category = .health
        case "음식":
            category = .food
        case "기타":
            category = .etc
        default:
            category = .etc
        }

        // Visibility 문자열을 enum으로 변환
        let visibility: VisibilityType
        switch dto.visibility {
        case "publicVisible":
            visibility = .publicVisible
        case "privateVisible":
            visibility = .privateVisible
        default:
            visibility = .privateVisible
        }

        // ImageSource 생성 (로컬 이미지)
        let imageSource = TimeStampLog.ImageSource.local(
            TimeStampLog.LocalTimeStampImage(imageFileName: dto.imageFileName)
        )

        return TimeStampLogViewData(
            id: dto.id,
            category: category,
            timeStamp: dto.timeStamp,
            imageSource: imageSource,
            visibility: visibility
        )
    }
}
