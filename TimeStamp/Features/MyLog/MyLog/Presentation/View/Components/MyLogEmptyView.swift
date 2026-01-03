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
            

            VStack(alignment: .center, spacing: 4) {
                Text("아직 남긴 기록이 없어요.")
                    .font(.Body1)
                    .foregroundStyle(Color.gray500)
                
                
                    Text("+ 버튼")
                    .font(FontStyle.SubTitle1.font)
                    + Text("을 눌러 기록을 시작해보세요!")
                    .font(FontStyle.Body1.font)
                        
            }
            .foregroundStyle(Color.gray500)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    MyLogEmptyView()
        .background(Color.black)
}
