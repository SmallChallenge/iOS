//
//  PinchZoomModifier.swift
//  TimeStamp
//
//  Created by 임주희 on 11/22/26.
//


import SwiftUI

struct PinchZoomModifier: ViewModifier {
    /// 현재 표시 줌 (camera.displayZoom)
    let currentZoom: CGFloat
    /// 계산된 목표 줌을 전달받는 콜백
    let onZoom: (CGFloat) -> Void

    /// 핀치 시작 시점의 줌 (핀치 중이 아니면 nil)
    @State private var startZoom: CGFloat?

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content.gesture(
                MagnifyGesture()
                    .onChanged { value in
                        handleChanged(value.magnification)
                    }
                    .onEnded { _ in
                        startZoom = nil
                    }
            )
        } else {
            content.gesture(
                MagnificationGesture()
                    .onChanged { value in
                        handleChanged(value)
                    }
                    .onEnded { _ in
                        startZoom = nil
                    }
            )
        }
    }

    private func handleChanged(_ magnification: CGFloat) {
        // 첫 변화 시점에 현재 줌을 기준값으로 저장
        if startZoom == nil {
            startZoom = currentZoom
        }
        onZoom((startZoom ?? currentZoom) * magnification)
    }
}

extension View {
    func pinchZoom(currentZoom: CGFloat, onZoom: @escaping (CGFloat) -> Void) -> some View {
        modifier(PinchZoomModifier(currentZoom: currentZoom, onZoom: onZoom))
    }
}