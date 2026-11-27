//
//  MyLogUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

struct MyLogUseCase: MyLogUseCaseProtocol {

    // MARK: - Properties

    private let repository: MyLogRepositoryProtocol
    
    /// Settings Repository
    private let settingsRepository: SettingsDataSourceProtocol
    
    private let authRepository: AuthRepositoryProtocol

    // MARK: - Init

    init(repository: MyLogRepositoryProtocol, settingsRepository: SettingsDataSourceProtocol, authRepository: AuthRepositoryProtocol) {
        self.repository = repository
        self.settingsRepository = settingsRepository
        self.authRepository = authRepository
    }

    // MARK: - Methods
    
    func fetchLogos(by category: Category?, pageInfo: PageInfo) async -> (logs: [TimeStampLog], hasNext: Bool) {
        var logs: [TimeStampLog] = []
        // 첫페이지면 로컬로그도 가져오기
        if pageInfo.currentPage == 0 {
            // 로컬 로그 가져오기
            do {
                if let category {
                    logs = try repository.fetchLogsFromLocal(by: category.rawValue)
                } else {
                    logs = try repository.fetchAllLogsFromLocal()
                }
                
            } catch {
                Logger.error("로컬 로그 가져오기 실패: \(error)")
            }
        }
        // 서버에서도 가져오기 (로그인 상태만)
        guard authRepository.isLoggedIn() else {
            return (logs, false)
        }
        
        guard pageInfo.hasNext else { return (logs, false) }
        var hasNextPage = false
        
        do {
            let result = try await repository.fetchAllLogFromServer(category: category?.rawValue, page: pageInfo.currentPage)
            logs.append(contentsOf: result.logs)
            hasNextPage = result.hasNext
        } catch {
            Logger.error("서버 로그 가져오기 실패 \(error)")
        }
        
        // timeStamp 기준으로 최신순 정렬
        let sortedLogs = logs.sorted { $0.timeStamp > $1.timeStamp }
        return (logs: sortedLogs, hasNext: hasNextPage)
    }
    

    /// 서버 로그 가져오기 (+ 페이지네이션)
    func fetchServerLogs(by category: Category?, pageInfo: PageInfo) async -> (logs: [TimeStampLog], hasNext: Bool) {
        do {
            let result = try await repository.fetchAllLogFromServer(category: category?.rawValue, page: pageInfo.currentPage)
            return (logs: result.logs, hasNext: result.hasNext)
        } catch {
            Logger.error("서버 로그 가져오기 실패 (page: \(pageInfo.currentPage)): \(error)")
            return (logs: [], hasNext: true)
        }
    }

    /// 로컬 타임스탬프 로그의 개수를 조회
    func getLocalLogsCount() -> Int {
        do {
            return try repository.fetchLocalLogsCount()
        } catch {
            Logger.error("로컬 로그 개수 조회 실패: \(error)")
            return 0
        }
    }
    
    func getIsLogLimitBannerDismissed() -> Bool {
        settingsRepository.getIsLogLimitBannerDismissed()
    }
    
    func dismissLogLimitBanner() {
        settingsRepository.setIsLogLimitBannerDismissed(true)
    }
}
