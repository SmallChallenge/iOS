//
//  CustomSnackbar.swift
//  TimeStamp
//
//  Created by 임주희 on 10/12/26.
//

import SwiftUI


struct CustomSnackbar: View {
    let message: String
    let buttonTitle: String
    let action: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            Text(message)
                .font(.Body2)
                .foregroundStyle(.gray50)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: action) {
                Text(buttonTitle)
                    .font(.Btn2_b)
                    .foregroundStyle(.neon300)
                    .fixedSize()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.gray800)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .roundedBorder(color: .gray700, radius: 8)
        .padding(.horizontal, 20)
    }
}

struct PreviewContentView: View {
    @State private var isSnackbarPresented = false
    
    var body: some View {
        ZStack {
            Color.yellow
            VStack {
                Button("스낵바 표시") {
                    withAnimation {
                        isSnackbarPresented = true
                    }
                    
                    Task {
                        try? await Task.sleep(for: .seconds(8))
                        
                        withAnimation(.easeOut(duration: 0.3)) {
                            isSnackbarPresented = false
                        }
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            if isSnackbarPresented {
                CustomSnackbar(
                    message: "변경사항이 저장되었습니다.",
                    buttonTitle: "실행취소",
                    action: {
                        withAnimation {
                            isSnackbarPresented = false
                        }
                    }
                )
                .padding(.bottom, 16)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}

#Preview {
    PreviewContentView()
        
}
