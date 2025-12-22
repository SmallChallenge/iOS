//
//  TagButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/22/25.
//

import SwiftUI

enum TagButtonState {
    case active
    case inactive
    case pressed

    var backgroundColor: Color {
        switch self {
        case .active:
            return .gray700
        case .inactive:
            return .gray800
        case .pressed:
            return .gray800
        }
    }

    var foregroundColor: Color {
        switch self {
        case .active:
            return .gray50
        case .inactive:
            return .gray300
        case .pressed:
            return .gray300
        }
    }

    var borderColor: Color {
        switch self {
        case .active, .pressed:
            return .clear
        case .inactive:
            return .gray700
        }
    }

    var font: FontStyle {
        switch self {
        case .active, .pressed:
            return .Btn2_b
        case .inactive:
            return .Btn2
        }
    }
}

// MARK: TagButton

struct TagView: View {
    let title: String
    let state: TagButtonState

    var body: some View {
        Text(title)
            .font(state.font)
            .foregroundColor(state.foregroundColor)
            .padding(.horizontal, 12)
            .frame(height: 37)
            .background(state.backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(state.borderColor, lineWidth: 1)
            )
    }
}


// MARK: - TagButton
struct TagButton: View {
    @State private var isActive = false
    let action: () -> Void

    var body: some View {
        Button {
            isActive.toggle()
            action()
        } label: {
            TagView(
                title: "Toggle Me",
                state: isActive ? .active : .inactive
            )
        }

    }
}


#Preview {
    VStack(spacing: 16) {
        TagView(title: "Active", state: .active)

        TagView(title: "Inactive", state: .inactive)
        
        TagView(title: "Pressed", state: .pressed)

        TagButton(){}
    }
    .padding()
    .background(Color.black)
}
