//
//  VisibilityViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

enum VisibilityViewData: String, CaseIterable {
    case publicVisible
    case privateVisible 
    
    var title: String {
        switch self {
        case .publicVisible: "전체 공개"
        case .privateVisible: "비공개"
        }
    }
}
