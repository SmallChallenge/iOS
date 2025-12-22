//
//  MainButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/22/25.
//

import SwiftUI

enum MainButtonSize {
    case large
    case middle
    case small

    var height: CGFloat {
        switch self {
        case .large:
            return 56
        case .middle:
            return 48
        case .small:
            return 34
        }
    }

    var fontStyle: FontStyle {
        switch self {
        case .large:
            return .Btn1_b
        case .middle:
            return .Btn1_b
        case .small:
            return .Btn2_b
        }
    }

    var cornerRadius: CGFloat {
        switch self {
        case .large, .middle:
            return 16
        case .small:
            return 8
        }
    }

    var width: CGFloat? {
        switch self {
        case .large, .middle:
            return nil
        case .small:
            return 50
        }
    }

    var maxWidth: CGFloat? {
        switch self {
        case .large, .middle:
            return .infinity
        case .small:
            return nil
        }
    }
}

enum MainButtonColorType {
    case primary
    case secondary
}

struct MainButtonStyle {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color

    static func style(for colorType: MainButtonColorType, isPressed: Bool, isDisabled: Bool) -> MainButtonStyle {
        switch (colorType, isDisabled, isPressed) {
        case (.primary, true, _):
            // Primary - Disabled
            return MainButtonStyle(
                backgroundColor: .gray300,
                foregroundColor: .gray500,
                borderColor: .clear
            )
        case (.primary, false, true):
            // Primary - Pressed
            return MainButtonStyle(
                backgroundColor: .neon400,
                foregroundColor: .gray900,
                borderColor: .clear
            )
        case (.primary, false, false):
            // Primary - Normal
            return MainButtonStyle(
                backgroundColor: .neon300,
                foregroundColor: .gray900,
                borderColor: .clear
            )
            
            
        case (.secondary, true, _):
            // Secondary - Disabled
            return MainButtonStyle(
                backgroundColor: .gray900,
                foregroundColor: .gray500,
                borderColor: .gray700
            )
        case (.secondary, false, true):
            // Secondary - Pressed
            return MainButtonStyle(
                backgroundColor: .gray900,
                foregroundColor: .gray400,
                borderColor: .gray500
            )
        case (.secondary, false, false):
            // Secondary - Normal
            return MainButtonStyle(
                backgroundColor: .gray900,
                foregroundColor: .gray300,
                borderColor: .gray400
            )
        }
    }
}
// MARK: - MainButton
struct MainButton: View {
    let title: String
    let size: MainButtonSize
    let colorType: MainButtonColorType
    let isDisabled: Bool
    let action: () -> Void

    @State private var isPressed: Bool = false

    init(
        title: String,
        size: MainButtonSize = .large,
        colorType: MainButtonColorType = .primary,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.size = size
        self.colorType = colorType
        self.isDisabled = isDisabled
        self.action = action
    }

    var body: some View {
        Button(action: {
            if !isDisabled {
                action()
            }
        }) {
            Text(title)
                .font(size.fontStyle)
                .frame(maxWidth: size.maxWidth)
                .frame(width: size.width)
                .frame(height: size.height)
                .foregroundColor(currentStyle.foregroundColor)
                .background(currentStyle.backgroundColor)
                .cornerRadius(size.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: size.cornerRadius)
                        .stroke(currentStyle.borderColor, lineWidth: 1)
                )
        }
        .buttonStyle(PressableButtonStyle(isPressed: $isPressed))
        .disabled(isDisabled)
    }

    private var currentStyle: MainButtonStyle {
        MainButtonStyle.style(for: colorType, isPressed: isPressed, isDisabled: isDisabled)
    }
}

struct PressableButtonStyle: ButtonStyle {
    @Binding var isPressed: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .onChange(of: configuration.isPressed) { newValue in
                isPressed = newValue
            }
    }
}

#Preview {
    VStack(spacing: 20) {
        // Large
        MainButton(title: "Large Primary", size: .large, colorType: .primary) {
            print("Tapped")
        }

        MainButton(title: "Large Secondary", size: .large, colorType: .secondary) {
            print("Tapped")
        }

        MainButton(title: "Large Disabled", size: .large, colorType: .primary, isDisabled: true) {
            print("Tapped")
        }

        // Middle
        MainButton(title: "Middle Primary", size: .middle, colorType: .primary) {
            print("Tapped")
        }

        MainButton(title: "Middle Secondary", size: .middle, colorType: .secondary) {
            print("Tapped")
        }

        // Small
        MainButton(title: "버튼", size: .small, colorType: .primary) {
            print("Tapped")
        }

        MainButton(title: "버튼", size: .small, colorType: .secondary) {
            print("Tapped")
        }
    }
    .padding()
}



