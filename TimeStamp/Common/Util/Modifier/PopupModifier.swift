//
//  PopupModifier.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import SwiftUI

struct PopupModifier<PopupContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let popupContent: () -> PopupContent
    
    func body(content: Content) -> some View {
        ZStack {
            
            content
            
            if isPresented {
                // 배경
                Color.gray900.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)

                popupContent()
                    .padding(.horizontal,30)
                    .scaleEffect(isPresented ? 1.0 : 0.8)
                    .opacity(isPresented ? 1.0 : 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(
            isPresented
                ? .spring(response: 0.3, dampingFraction: 0.8)
                : .easeOut(duration: 0.2),
            value: isPresented
        )
    }
}

extension View {
    func popup<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(PopupModifier(isPresented: isPresented, popupContent: content))
    }
}
