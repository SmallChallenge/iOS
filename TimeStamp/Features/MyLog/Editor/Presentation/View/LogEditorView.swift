//
//  LogEditorView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import SwiftUI

struct LogEditorView: View {
    
    let onDismiss: () -> Void
    
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(" 기록 수정 화면")
                    .font(.Body1)
                    .foregroundStyle(Color.gray50)
            }// ~Vstack
            .mainBackgourndColor()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 닫기 버튼
                    CloseButton {
                        onDismiss()
                    }
                    .padding(.trailing, -12)
                }
            }
        }
        
    }
}

#Preview {
    LogEditorView(onDismiss: {})
}
