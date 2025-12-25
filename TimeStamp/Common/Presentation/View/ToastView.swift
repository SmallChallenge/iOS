//
//  ToastView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import SwiftUI

// MARK: - Toast View

struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.Body1)
            .foregroundColor(.gray50)
            .multilineTextAlignment(.center)
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray900)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray700, lineWidth: 1)
            )
            //.shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Toast Modifier

struct ToastModifier: ViewModifier {
    @Binding var message: String?

    @State private var workItem: DispatchWorkItem?
    @State private var isShowing: Bool = false

    private let duration: TimeInterval = 2.0
    private let animation: Animation = .spring(response: 0.4, dampingFraction: 0.8)

    func body(content: Content) -> some View {
        ZStack {
            content

            if let message = message {
                VStack {
                    Spacer()

                    ToastView(message: message)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 50)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            )
                        )
                        .opacity(isShowing ? 1 : 0)
                        .offset(y: isShowing ? 0 : 20)
                }
                .zIndex(999)
            }
        }
        .onChange(of: message) { newValue in
            showToast()
        }
    }

    private func showToast() {
        guard message != nil else {
            isShowing = false
            return
        }

        // 기존 작업 취소
        workItem?.cancel()

        // 토스트 표시
        withAnimation(animation) {
            isShowing = true
        }

        // 일정 시간 후 토스트 숨김
        let task = DispatchWorkItem {
            withAnimation(animation) {
                isShowing = false
            }

            // 애니메이션 완료 후 메시지 제거
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                message = nil
            }
        }

        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
}

// MARK: - View Extension

extension View {
    /// 토스트 메시지를 표시하는 modifier
    /// - Parameter message: 표시할 메시지 (nil이면 토스트 숨김)
    /// - Returns: 토스트 메시지가 적용된 View
    func toast(message: Binding<String?>) -> some View {
        modifier(ToastModifier(message: message))
    }
}

// MARK: - Preview

#Preview("토스트 테스트") {
    ToastPreviewContainer()
}

struct ToastPreviewContainer: View {
    @State private var toastMessage: String? = nil

    var body: some View {
        VStack(spacing: 20) {
            MainButton(title: "성공 토스트") {
                toastMessage = "저장이 완료되었어요."
            }

            MainButton(title: "에러 토스트") {
                toastMessage = "저장에 실패했어요.\n다시 시도해 주세요."
            }

            MainButton(title: "긴 메시지 토스트") {
                toastMessage = "이것은 아주 긴 토스트 메시지입니다.\n여러 줄로 표시될 수 있습니다.\n최대한 간결하게 작성하는 것이 좋습니다."
            }
        }
        .padding()
        .mainBackgourndColor()
        .toast(message: $toastMessage)
    }
}
