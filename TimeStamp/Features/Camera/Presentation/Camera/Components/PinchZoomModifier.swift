//
//  PinchZoomModifier.swift
//  TimeStamp
//
//  Created by 임주희 on 11/22/26.
//


import SwiftUI

struct PinchZoomModifier: ViewModifier {
    let currentZoom: CGFloat
    /// 줌할 때 보여줄 텍스트
    let message: String
    /// 텍스트 노출 시간(초)
    let displayDuration: Double
    let onZoom: (CGFloat) -> Void

    @State private var startZoom: CGFloat?
    @State private var isMessageVisible = false
    @State private var hideTask: Task<Void, Never>?

    func body(content: Content) -> some View {
        gestureApplied(content)
            .overlay(alignment: .top) {
                if isMessageVisible {
                    ZStack(alignment: .center) {
                        Capsule()
                            .frame(width: 50, height: 33, alignment: .center)
                            .foregroundStyle(Color.black.opacity(0.5))
                        Text(message)
                            .font(.pretendard(.medium), size: 14)
                            .foregroundStyle(.neon300)
                    }
                    .padding(.top, 16)
                    .transition(.opacity)
                    .allowsHitTesting(false)
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isMessageVisible)
            .onDisappear { hideTask?.cancel() }
    }

    @ViewBuilder
    private func gestureApplied(_ content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.gesture(
                MagnifyGesture()
                    .onChanged { handleChanged($0.magnification) }
                    .onEnded { _ in handleEnded() }
            )
        } else {
            content.gesture(
                MagnificationGesture()
                    .onChanged { handleChanged($0) }
                    .onEnded { _ in handleEnded() }
            )
        }
    }

    private func handleChanged(_ magnification: CGFloat) {
        if startZoom == nil {
            startZoom = currentZoom
        }
        onZoom((startZoom ?? currentZoom) * magnification)

        // 핀치 중에는 계속 보이게 하고, 기존 숨김 예약은 취소
        isMessageVisible = true
        hideTask?.cancel()
    }

    private func handleEnded() {
        startZoom = nil
        scheduleHide()
    }

    /// displayDuration 뒤에 텍스트 숨기기 (새 줌이 들어오면 취소됨)
    private func scheduleHide() {
        hideTask?.cancel()
        hideTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(displayDuration * 1_000_000_000))
            guard !Task.isCancelled else { return }
            isMessageVisible = false
        }
    }
}

extension View {
    func pinchZoom(
        currentZoom: CGFloat,
        message: String,
        displayDuration: Double = 2.0,
        onZoom: @escaping (CGFloat) -> Void
    ) -> some View {
        modifier(PinchZoomModifier(
            currentZoom: currentZoom,
            message: message,
            displayDuration: displayDuration,
            onZoom: onZoom
        ))
    }
}

