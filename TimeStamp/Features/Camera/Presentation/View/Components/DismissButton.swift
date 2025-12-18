//
//  DismissButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI

/// 뒤로가기 버튼 컴포넌트
/// - @Environment(\.dismiss) 대신 클로저 기반으로 동작하여 성능 최적화
struct DismissButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundStyle(.gray50)
        }
    }
}
