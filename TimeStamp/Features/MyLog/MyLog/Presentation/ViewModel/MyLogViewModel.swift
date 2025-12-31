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

    /// Settings Repository
    private let settingsRepository: SettingsDataSourceProtocol

    // MARK: - Output Properties

    @Published var isLoading = false
    @Published var isLoadingMore = false

    @Published var toastMessage: String?
    @Published var alertMessage: String?

    /// 전체 로그 (필터링은 View에서 수행)
    @Published var myLogs: [TimeStampLogViewData] = []

    /// 로컬 기록 개수
    @Published var localLogsCount: Int = 0

    /// 로그 제한 배너를 닫았는지 여부
    @Published var isLogLimitBannerDismissed: Bool = false

    /// 페이지네이션 상태
    private var currentPage = 0
    private var hasMorePages = false

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

    init(useCase: MyLogUseCaseProtocol, settingsRepository: SettingsDataSourceProtocol) {
        self.useCase = useCase
        self.settingsRepository = settingsRepository

        // 배너 닫힘 상태 불러오기
        self.isLogLimitBannerDismissed = settingsRepository.getIsLogLimitBannerDismissed()

        loadLogs()
    }

    // MARK: - Input Methods

    /// 모든 로그를 불러오기
    func loadLogs() {
        // 중복 호출 방지
        guard isLoading == false && isLoadingMore == false
        else { return }

        isLoading = true
        Task {
            // 페이지 초기화
            currentPage = 0
            hasMorePages = false

            let isLoggedIn = AuthManager.shared.isLoggedIn
            let result = await useCase.fetchAllLogs(isLoggedIn: isLoggedIn)

            myLogs = result.logs.map { $0.toViewData() }

            // 로컬 로그 개수 업데이트
            localLogsCount = useCase.getLocalLogsCount()

            // 페이지네이션 정보 업데이트
            if let pageInfo = result.pageInfo {
                currentPage = pageInfo.currentPage
                hasMorePages = pageInfo.hasNext
            }

            isLoading = false
            Logger.success("로그 불러오기 성공: \(myLogs.count)개, 로컬: \(localLogsCount)개, hasMore: \(hasMorePages)")
        }
    }

    /// 다음 페이지 로그 불러오기 (서버 로그만)
    func loadMore() {
        // 중복 호출 방지
        guard !isLoading && !isLoadingMore else { return }

        // 다음 페이지가 없으면 리턴
        guard hasMorePages else {
            return
        }

        // 로그인 상태가 아니면 리턴 (서버 로그만 페이지네이션)
        guard AuthManager.shared.isLoggedIn else {
            return
        }

        isLoadingMore = true
        Task {
            let nextPage = currentPage + 1
            let result = await useCase.fetchServerLogs(page: nextPage)

            // 새로운 로그를 기존 로그와 합치고 정렬(최신순)
            let newLogs = result.logs.map { $0.toViewData() }
            myLogs = (myLogs + newLogs) //.sorted { $0.timeStamp > $1.timeStamp } // 정렬안해도 될껄?

            // 페이지네이션 정보 업데이트
            if let pageInfo = result.pageInfo {
                currentPage = pageInfo.currentPage
                hasMorePages = pageInfo.hasNext
            } else {
                hasMorePages = false
            }

            isLoadingMore = false
            Logger.success("추가 로그 불러오기 성공: \(newLogs.count)개, 현재 페이지: \(currentPage), hasMore: \(hasMorePages)")
        }
    }

    /// 로그 제한 배너 닫기
    func dismissLogLimitBanner() {
        isLogLimitBannerDismissed = true
        settingsRepository.setIsLogLimitBannerDismissed(true)
    }
}
