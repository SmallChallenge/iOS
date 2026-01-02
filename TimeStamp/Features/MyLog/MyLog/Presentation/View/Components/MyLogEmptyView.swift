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
            
            Image("img_mr_empty")
                .resizable()
                .frame(width: 140, height: 140)
            

            VStack(alignment: .leading, spacing: 4) {
                Text("아직 남긴 기록이 없어요.")
                    .font(.Body1)
                    .foregroundStyle(Color.gray500)
                
                HStack(spacing: 0) {
                    Text("+ 버튼")
                        .font(.Body1)
                        .overlay(
                            Rectangle()
                                .fill(Color.gray500)
                                .frame(height: 1)
                                .offset(y: 2),
                            alignment: .bottom
                        )
                        .foregroundStyle(Color.gray500)
                    Text("을 눌러 기록을 시작해보세요!")
                        .font(.Body1)
                        .foregroundStyle(Color.gray500)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MyLogEmptyView()
        .background(Color.black)
}
