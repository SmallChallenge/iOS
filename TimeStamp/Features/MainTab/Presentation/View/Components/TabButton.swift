//
//  TabButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct TabButton: View {
    let type: MainTabViewIcon
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            if isSelected {
                Image(type.iconName)
                    .frame(width: 24, height: 24)
                    
            } else {
                Image(type.selectedIconName)
                    .font(.system(size: 22))
                    .frame(width: 24, height: 24)
                    
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
