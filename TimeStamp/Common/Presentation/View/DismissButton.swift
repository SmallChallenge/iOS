//
//  DismissButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI

/// 뒤로가기 버튼 컴포넌트
struct DismissButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundStyle(.gray50)
        }
    }
}
