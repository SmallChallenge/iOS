//
//  CheckBox.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import SwiftUI

struct CheckBox: View {
    @Binding var isChecked: Bool
    let title: String

    init(isChecked: Binding<Bool>, title: String) {
        self._isChecked = isChecked
        self.title = title
    }

    var body: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isChecked.toggle()
            }
        } label: {
            HStack(spacing: 12) {
                // 체크박스
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(isChecked ? Color.neon300 : Color.gray400, lineWidth: 1.5)
                        .frame(width: 20, height: 20)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isChecked ? Color.neon300 : Color.clear)
                        )

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray900)
                    }
                }

                // 텍스트
                Text(title)
                    .font(.Body1)
                    .foregroundStyle(Color.gray50)

                Spacer()
            }
        }
        .buttonStyle(.plain)
    }
}

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
            CheckBox(isChecked: $isChecked1, title: "이용약관 동의")
            CheckBox(isChecked: $isChecked2, title: "개인정보 처리방침 동의")
        }
    }
}
