//
//  BackButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import SwiftUI

/// 뒤로가기 버튼 컴포넌트
struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .frame(width: 24, height: 24)
                .foregroundStyle(.gray50)
                .padding(10)
                
                
        }
        .buttonStyle(.plain)
    }
}
#Preview {
    BackButton(action: {})
        
}



