//
//  CloseButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import SwiftUI

/// 닫기 버튼 컴포넌트
struct CloseButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image("close_line")
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray50)
                .padding(12)
        }
        .buttonStyle(.plain)
    }
}
