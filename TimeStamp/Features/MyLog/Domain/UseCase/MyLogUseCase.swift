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

    // MARK: - Init

    init(repository: MyLogRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Methods

    /// 모든 타임스탬프 로그를 조회
    func fetchAllLogs(isLoggedIn: Bool) async -> (logs: [TimeStampLog], pageInfo: PageInfo?) {

        // 로컬 로그 가져오기
        let localLogs: [TimeStampLog]
        do {
            localLogs = try repository.fetchAllLogsFromLocal()
        } catch {
            Logger.error("로컬 로그 가져오기 실패: \(error)")
            localLogs = []
        }

        // 서버 로그 가져오기 (로그인 상태일 때만)
        var serverLogs: [TimeStampLog] = []
        var pageInfo: PageInfo? = nil

        if isLoggedIn {
            let result = await fetchServerLogs(page: 0)
            serverLogs = result.logs
            pageInfo = result.pageInfo
        }

        // 로컬 로그와 서버 로그를 합치고, timeStamp 기준으로 최신순 정렬
        let allLogs = localLogs + serverLogs
        let sortedLogs = allLogs.sorted { $0.timeStamp > $1.timeStamp }

        return (logs: sortedLogs, pageInfo: pageInfo)
    }

    /// 서버 로그 가져오기 (+ 페이지네이션)
    func fetchServerLogs(page: Int) async -> (logs: [TimeStampLog], pageInfo: PageInfo?) {
        do {
            let result = try await repository.fetchAllLogFromServer(page: page)
            return (logs: result.logs, pageInfo: result.pageInfo)
        } catch {
            Logger.error("서버 로그 가져오기 실패 (page: \(page)): \(error)")
            return (logs: [], pageInfo: nil)
        }
    }
}
