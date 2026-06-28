//
//  MainTabUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 4/30/26.
//

import Foundation

struct MainTabUseCase: MainTabUseCaseProtocol {
    
    private let myLogRepository: MyLogRepositoryProtocol
    private let repository: MainTabRepositoryProtocol
    init(repository: MainTabRepositoryProtocol, myLogRepository: MyLogRepositoryProtocol) {
        self.repository = repository
        self.myLogRepository = myLogRepository
    }
    
    /// 로컬 타임스탬프 로그의 개수를 조회
    func getLocalLogsCount() -> Int {
        do {
            return try myLogRepository.fetchLocalLogsCount()
        } catch {
            Logger.error("로컬 로그 개수 조회 실패: \(error)")
            return 0
        }
    }
    
    
    // 리뷰유도 팝업 열수있나 확인
    func checkShowReviewPopup() -> Bool {
        return repository.getCanReviewOpen()
    }
    
    // 리뷰팝업뜨기에 딜레이주기
    func setReviewDelayed(days: Int){
        repository.setReviewDelayed(days: days)
    }
}
