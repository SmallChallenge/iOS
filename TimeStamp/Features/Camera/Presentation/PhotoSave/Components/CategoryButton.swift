//
//  CategoryButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//


import SwiftUI


struct CategoryButton: View {
    
    enum State {
        case normal
        case selected
        case unselected
    }
    let type: CategoryViewData
    let state: State
    let action: () -> Void
    
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                
                // 아이콘
                Image(type.image)
                    .resizable()
                    .frame(width: 48, height: 48)
                    .opacity(imageOpacity)
                
                // 이름
                Text(type.title)
                    .font(titleFont)
                    .foregroundStyle(titleColor)
            }
        }
    }
    
    var imageOpacity: Double {
        switch state {
        case .selected: 1.0
        case .normal, .unselected: 0.4
        }
    }
    var titleFont: FontStyle {
        switch state {
        case .selected: .Btn2_b
        case .normal,.unselected: .Btn2
        }
    }
    
    var titleColor: Color {
        switch state {
        case .selected: Color.gray50
        case .normal, .unselected: Color.gray500
        }
    }
}
