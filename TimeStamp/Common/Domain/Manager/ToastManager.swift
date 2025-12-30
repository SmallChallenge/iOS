//
//  ToastManager.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import SwiftUI
import Combine

final class ToastManager: ObservableObject {
    static let shared = ToastManager()

    @Published var message: String?

    private init() {}

    /// 토스트 메시지 표시
    func show(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.message = message
        }
    }

    /// 토스트 숨김
    func hide() {
        DispatchQueue.main.async { [weak self] in
            self?.message = nil
        }
    }
}
