//
//  MyLogViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation
import Combine
import UIKit

@MainActor
final class MyLogViewModel: ObservableObject, MessageDisplayable {

    // MARK: - Properties

    /// MyLog UseCase
    private let useCase: MyLogUseCaseProtocol
    
    private var loadTask: Task<Void, Never>?

    // MARK: - Output Properties
    
    // 로그인 여부
    @Published private(set) var isLoggedIn = false
    private let authStateProvider: AuthStateProviding
    private var cancellables = Set<AnyCancellable>()
    
    // 선택된 카테고리
    @Published var selectedCategory: CategoryFilterViewData = .all

    @Published var isLoading = false
    @Published var isLoadingMore = false

    @Published var toastMessage: String?
    @Published var alertMessage: String?

    /// 전체 로그
    @Published var myLogs: [TimeStampLogViewData] = []

    /// 로컬 기록 개수
    @Published var localLogsCount: Int = 0

    /// 로그 제한 배너를 닫았는지 여부
    @Published var isLogLimitBannerDismissed: Bool = false

    /// 페이지네이션 상태
    private var pageInfo = PageInfo()
    
    private let screenHeight = UIScreen.main.bounds.height
    
    // 보이는 영역에서 최대한 중앙에 맞추기 위한 노력
    var emptyViewHeight: CGFloat {
        // 헤더: 60
        // 카테고리 113
        // 하단 탭바 대충 100
        let logLimitBannerHeight: CGFloat = (shouldShowLogLimitBanner ? 152.0 : 0.0)
        let otherHeight = 60.0 + 113.0 + logLimitBannerHeight + 150
        return screenHeight - otherHeight
    }

    /// 로그 제한 배너 표시 여부
    var shouldShowLogLimitBanner: Bool {
        localLogsCount >= LogPolicy.warningLogCount // 18개 이상이면 뜬다
            && !isLogLimitBannerDismissed // 한번 닫으면 안뜬다.
            && !isLoggedIn // 로그아웃 상태일때만
    }

    // MARK: - Init

    init(useCase: MyLogUseCaseProtocol, authStateProvider: AuthStateProviding) {
        self.useCase = useCase
        self.authStateProvider = authStateProvider
        
        bindAuthState()

        // 배너 닫힘 상태 불러오기
        self.isLogLimitBannerDismissed = useCase.getIsLogLimitBannerDismissed()

    }
    
    /// 로그인 여부 옵저빙
    private func bindAuthState() {
        authStateProvider.isLoggedInPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLoggedIn)
        
        /*authStateProvider.currentUserPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentUser)*/
    }

    // MARK: - Input Methods
    
    // 로컬 로그 개수 업데이트
    func updateLocalLogsCount(){
        localLogsCount = useCase.getLocalLogsCount()
    }
    
    /// 카테고리  선택함
    func selectCategory(_ category: CategoryFilterViewData) {
        selectedCategory = category
        refreshLogs()
    }
    
    func refreshLogs(){
        pageInfo.reset() // 페이지 초기화
        loadLogs()
    }
    
    /// 다음 페이지 로그 불러오기 (서버 로그만)
    func loadMore() {
        guard isLoggedIn else { return }
        // 다음 페이지가 없으면 리턴
        guard pageInfo.hasNext else { return }
        pageInfo.nextPage()
        loadLogs()
    }
    
    /// 로그 불러오기
    private func loadLogs(){
        
        // 이전 요청 취소
        loadTask?.cancel()
        
        isLoading = true
        loadTask = Task {
            do {
                let result = try await useCase.fetchLogos(
                    by: selectedCategory.category,
                    pageInfo: pageInfo
                )
                // 취소된 요청의 결과 반영 방지
                guard !Task.isCancelled else { return }
                
                let logs = result.logs.map { $0.toViewData()}
                if pageInfo.currentPage == 0 { // 첫페이지면 데이터 교체
                    myLogs = logs
                } else { // 그 다음 페이지면 이어붙이기
                    myLogs.append(contentsOf: logs)
                }
                
                // 페이지네이션 정보 업데이트
                pageInfo.updateHasNext(result.hasNext)
                Logger.success("로그 불러오기 성공: \(myLogs.count)개, hasNextPage: \(pageInfo.hasNext)")
                
            } catch is CancellationError {
                Logger.warning("취소된 요청")
            } catch {
                guard !Task.isCancelled else { return }
                Logger.error("서버 로그 가져오기 실패 \(error)")
                toastMessage = AppMessage.loadFailed.text
            }
            isLoading = false
        }
    }


    /// 로그 제한 배너 닫기
    func dismissLogLimitBanner() {
        isLogLimitBannerDismissed = true
        useCase.dismissLogLimitBanner()
    }
    
    func hideLog(uuid: UUID){
        myLogs.removeAll { $0.id == uuid }
    }
}
