//
//  View+Extension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation
import SwiftUI



extension View {
    
    func roundedBorder(color: Color, radius: CGFloat, lineWidth: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: lineWidth)
        )
    }
    
    
    func rounded(radius: CGFloat) -> some View {
        self.clipShape(
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                
        )
    }
    
    @ViewBuilder
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            content(self)
        } else {
            self
        }
    }

}



// MARK: - 화면 배경 검게하는거

public struct MainBackgroundColorModified: ViewModifier {
    private var color: Color
    
    public init(color: Color) {
        self.color = color
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            color
            
            content
        }
        .background(color)
    }
}
 extension View {
    func mainBackgourndColor(_ color: Color = .gray900) -> ModifiedContent<Self, MainBackgroundColorModified> {
        modifier(MainBackgroundColorModified(color: color))
    }
}

// MARK: - 로딩 뷰 코드 간소화

struct LoadingModifier: ViewModifier {
    let isLoading: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isLoading {
                ProgressView()
                    .tint(.neon300)
                    .scaleEffect(1.5)
            }
        }
    }
}

extension View {
    func loading(_ isLoading: Bool) -> some View {
        modifier(LoadingModifier(isLoading: isLoading))
    }
}


