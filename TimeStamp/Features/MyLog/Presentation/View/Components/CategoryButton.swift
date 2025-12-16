//
//  CategoryButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CategoryButton: View {
    let type: CategoryViewData
    let isSelected: Bool
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                // 아이콘
                Image(type.image)
                    .resizable()
                    .frame(width: 56, height: 56)
                    .opacity(isSelected ? 1.0 : 0.4)
                
                // 이름
                Text(type.title)
                    .font(.Btn2_b)
                    .foregroundStyle(isSelected ? Color.gray50 : Color.gray500)
            }
        }
    }
}
