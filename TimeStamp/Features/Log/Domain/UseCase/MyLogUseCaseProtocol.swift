//
//  MyLogUseCaseProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

protocol MyLogUseCaseProtocol {

    func fetchLogos(by category: Category?, pageInfo: PageInfo) async -> (logs: [TimeStampLog], hasNext: Bool) 

    /// 로컬 타임스탬프 로그의 개수를 조회
    /// - Returns: 로컬에 저장된 로그의 개수
    func getLocalLogsCount() -> Int
    
    
    // 배너 닫힘 상태 불러오기
    func getIsLogLimitBannerDismissed() -> Bool
    /// 로그 제한 배너 닫기
    func dismissLogLimitBanner()
}
