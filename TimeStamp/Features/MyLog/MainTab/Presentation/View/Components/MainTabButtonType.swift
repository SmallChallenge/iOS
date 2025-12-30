//
//  MainTabButtonType.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation

enum MainTabButtonType {
    case myLog
    case camera
    case community
    
    
    var iconName: String {
        switch self {
            
        case .myLog:
            "IconRecord_Outline"
        case .camera:
            "IconAdd"
        case .community:
            "IconCommunity_Outline"
        }
    }
    
    var selectedIconName: String {
        switch self {
        case .myLog:
            "IconRecord_Filled"
        case .camera:
            "IconAdd"
        case .community:
            "IconCommunity_Filled"
        }
    }
    
    var buttonName: String {
        switch self {
        case .myLog:
            "내 기록"
        case .camera:
            ""
        case .community:
            "커뮤니티"
        }
    }
}
