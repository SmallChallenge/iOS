//
//  VisibilityTypeMapper.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation


// MARK: (ViewData) -> (Entity)
// MARK: VisibilityViewData -> VisibilityType
// VisibilityType가 common이라 mapper 만듦
struct VisibilityTypeMapper {
    func toEntity(from viewData: VisibilityViewData) -> VisibilityType {
           switch viewData {
           case .publicVisible: return .publicVisible
           case .privateVisible: return .privateVisible
           }
       }
}

// MARK: (Entity) -> (ViewData)
// MARK: VisibilityType -> VisibilityViewData
struct VisibilityViewDataMapper {
    func toViewData(from entity: VisibilityType) -> VisibilityViewData {
        switch entity {
        case .publicVisible: return .publicVisible
        case .privateVisible: return .privateVisible
        }
    }
}
