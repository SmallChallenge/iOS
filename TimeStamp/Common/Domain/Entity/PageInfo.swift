//
//  PageInfo.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation

/// 페이지네이션 정보 Entity
struct PageInfo {
    private(set) var currentPage: Int = 0
    private(set) var hasNext: Bool = true
    
    init (){}
    
    init(currentPage: Int, hasNext: Bool) {
        self.currentPage = currentPage
        self.hasNext = hasNext
    }
    
    mutating func reset() {
        currentPage = 0
        hasNext = true
    }
    
    mutating func nextPage(){
        guard hasNext else { return }
        self.currentPage += 1
    }
    
    mutating func updateHasNext(_ hasNext: Bool) {
        self.hasNext = hasNext
    }
}
