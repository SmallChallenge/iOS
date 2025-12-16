//
//  CategoryViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//


enum CategoryViewData: CaseIterable {
    case all
    case food
    case study
    case health
    
    var title: String {
        switch self {
        case .all: return "전체"
        case .food: return "음식"
        case .study: return "공부"
        case .health: return "운동"
        }
    }
    
    var image: String {
        switch self {
        case .all: return "sample_category"
        case .food: return "sample_category"
        case .study: return "sample_category"
        case .health: return "sample_category"
        }
    }
}
