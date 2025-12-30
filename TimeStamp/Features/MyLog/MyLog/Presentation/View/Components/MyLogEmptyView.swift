//
//  MyLogEmptyView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import SwiftUI

/// 내기록 > 사진 없음 뷰
struct MyLogEmptyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            
            Image("sample_category")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("기록을 추가해보세요~!")
                .font(.Body1)
                .foregroundStyle(Color.gray50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MyLogEmptyView()
        .background(Color.black)
}
