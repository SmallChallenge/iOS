//
//  MainTabRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 4/30/26.
//


import Foundation

protocol MainTabRepositoryProtocol {
    func getCanReviewOpen() -> Bool
    func setReviewDelayed(days: Int)
    
    
    /// 자동저장 여부 조회 (기본값: true)
    func getIsAutoSave() -> Bool
    func setIsAutoSave(_ isAutoSave: Bool)
    
    /// 앱 설치 후 첫 저장인지 (기본값: true)
    func getIsFirstSave() -> Bool
    func setIfFirstSave(_ isFirstSave: Bool)
    
}
