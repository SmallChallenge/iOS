//
//  CategoryViewDataMapper.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

/// Entity -> ViewData
struct CategoryViewDataMapper {
    func toViewData(from entity: Category) -> CategoryViewData {
        switch entity {
            
        case .food:
            return .food
        case .study:
            return .study
        case .health:
            return .health
        case .etc:
            return .etc
        }
    }
}

/// ViewData -> Entity
struct CategoryMapper {
    func toEntity(from viewData: CategoryViewData) -> Category {
        switch viewData {
        case .food:
            return .food
        case .study:
            return .study
        case .health:
            return .health
        case .etc:
            return .etc
        }
    }
}
