//
//  CustomTabBar.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

enum MainTabViewIcon {
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
    
    
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // 내 기록
            TabButton(
                type: .myLog,
                isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
           
            
            // 카메라
            Button {
                selectedTab = 1
            } label: {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.white)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
            }
            .offset(y: -25) // 위로 튀어나오게
            
            // 커뮤니티
            TabButton(
                type: .community,
                isSelected: selectedTab == 3) {
                    selectedTab = 2
                }
            
            
        }
        .frame(height: 60)
        .background(
            Color.white
                .shadow(color: .black.opacity(0.1), radius: 5, y: -2)
        )
    }
}


