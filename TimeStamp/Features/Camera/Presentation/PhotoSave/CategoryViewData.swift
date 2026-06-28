//
//  CategoryViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//


enum CategoryViewData: String, CaseIterable {
    case study
    case health
    case food
    case etc


    var title: String {
        switch self {
        case .study: return "공부"
        case .health: return "운동"
        case .food: return "음식"
        case .etc: return "기타"
        }
    }

    var image: String {
        switch self {
        case .study: return "category_study"
        case .health: return "category_health"
        case .food: return "category_food"
        case .etc: return "category_etc"
        }
    }
    
    var iconImage: String {
        switch self {
        case .study: return "icon_category_study"
        case .health: return "icon_category_health"
        case .food: return "icon_category_food"
        case .etc: return "icon_category_etc"
        }
    }
}
