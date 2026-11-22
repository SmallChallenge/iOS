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
    
    // 리뷰 팝업 뜨기에 딜레이주기 (n일뒤에 뜨기)
    func setReviewDelayed(days: Int){
        repository.setReviewDelayed(days: days)
    }
    
    // 자동저장끄기 스낵바 띄우기 여부 확인
    func checkAutoSaveSnackBar() -> Bool {
        // 자동 저장 여부 확인: 자동 저장 on 으로 되어있음 && 처음으로 사진 저장함.
        
        // 자동저장여부
        let isAutoSave = repository.getIsAutoSave()
        
        // 첫 저장인지 확인
        let isFirstSave = repository.getIsFirstSave()
        
        // 이제 첫 저장 아님..
        if isFirstSave {
            repository.setIfFirstSave(false)
        }

        return isAutoSave && isFirstSave
    }
    
    // 자동저장 끄기
    func setAutoSaveOff() {
        repository.setIsAutoSave(false)
    }
}
