//
//  TabButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct TabButton: View {
    let type: MainTabButtonType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                // 아이콘
                Image(isSelected ? type.selectedIconName : type.iconName)
                    .renderingMode(.template)
                    .foregroundStyle(isSelected ? .gray50 : .gray600)
                    .frame(width: 24, height: 24)
                
                
                // 이름
                Text(type.buttonName)
                    .font(.Label)
                    .foregroundStyle(isSelected ? .gray50 : .gray600)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

