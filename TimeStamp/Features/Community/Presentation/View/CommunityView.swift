//
//  CommunityView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CommunityView: View {
    var body: some View {
        ZStack{
            if true {
                emptyView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        
                        
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .mainBackgourndColor()
    }
    
    private var emptyView: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("img_cm_empty")
                .resizable()
                .frame(width: 140, height: 140)
            
            VStack (alignment: .center, spacing: 8){
                Text("아직은 우리만의 비밀 공간 같아요.")
                    .font(.Body1)
                    .foregroundStyle(Color.gray500)
                
                Text("첫 게시물로 문을 열어주세요.")
                    .font(.Body1)
                    .foregroundStyle(Color.gray500)
            }
        }
    }
}

#Preview {
    CommunityView()
}
