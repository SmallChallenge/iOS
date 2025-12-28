//
//  CheckBox.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import SwiftUI

// MARK: - CheckBox (View only)

struct CheckBox<Label: View>: View {
    let isChecked: Bool
    let label: Label

    init(isChecked: Bool, @ViewBuilder label: () -> Label) {
        self.isChecked = isChecked
        self.label = label()
    }

    var body: some View {
        HStack(spacing: 12) {
            // 체크박스
            Circle()
                .stroke(isChecked ? Color.neon500 : Color.gray300, lineWidth: 1.5)
                .frame(width: 20, height: 20)
                .background(
                    Circle()
                        .fill(isChecked ? Color.neon500 : Color.clear)
                )

            // 라벨
            label

            Spacer()
        }
    }
}

// MARK: - CheckBoxButton (with action)

struct CheckBoxButton<Label: View>: View {
    @Binding var isChecked: Bool
    let label: Label

    init(isChecked: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self._isChecked = isChecked
        self.label = label()
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isChecked.toggle()
            }
        } label: {
            CheckBox(isChecked: isChecked, label: { label })
        }
        .buttonStyle(.plain)
    }
}

// MARK: - String 편의 init

extension CheckBox {
    init(isChecked: Bool, title: String) where Label == AnyView {
        self.isChecked = isChecked
        self.label = AnyView(
            Text(title)
                .font(.Body1)
                .foregroundStyle(Color.gray50)
        )
    }
}

extension CheckBoxButton {
    init(isChecked: Binding<Bool>, title: String) where Label == AnyView {
        self._isChecked = isChecked
        self.label = AnyView(
            Text(title)
                .font(.Body1)
                .foregroundStyle(Color.gray50)
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        CheckBoxTestView()
    }
    .padding()
    .background(Color.gray900)
}

struct CheckBoxTestView: View {
    @State private var isChecked1 = false
    @State private var isChecked2 = true

    var body: some View {
        VStack(spacing: 20) {
            // CheckBoxButton - String 버전
            CheckBoxButton(isChecked: $isChecked1, title: "이용약관 동의")
            CheckBoxButton(isChecked: $isChecked2, title: "개인정보 처리방침 동의")

            // CheckBoxButton - View 버전
            CheckBoxButton(isChecked: $isChecked1) {
                HStack {
                    Text("마케팅 수신 동의")
                        .font(.Body1)
                    Text("(선택)")
                        .font(.Body1)
                        .foregroundColor(.gray500)
                }
                .foregroundStyle(Color.gray50)
            }

            Divider()

            // CheckBox (View only, no action)
            CheckBox(isChecked: isChecked1, title: "읽기 전용 체크박스")
        }
    }
}
