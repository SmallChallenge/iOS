//
//  MainTabUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 4/30/26.
//

import Foundation

protocol MainTabUseCaseProtocol {
    /// 로컬 타임스탬프 로그의 개수를 조회
    /// - Returns: 로컬에 저장된 로그의 개수
    func getLocalLogsCount() -> Int
    
    /// 리뷰유도 팝업 열수있나 확인
    func checkShowReviewPopup() -> Bool
    
    /// 다음에 하기 눌렀을때 딜레이주기
    func setReviewDelayed(days: Int)
}
