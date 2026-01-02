//
//  CommunityCard.swift
//  Stampic
//
//  Created by 임주희 on 1/2/26.
//

import SwiftUI

struct CommunityCard: View {
    var body: some View {
        VStack {
            
            // 헤더 (프로필 + ...메뉴)
            HStack {
                // 이미지뷰
                Image("profile")
                    .resizable()
                    .frame(width: 40, height: 40)

                    
                //
            }
            
            // 이미지뷰
            
            // 좋아요
            
        }
    }
}

#Preview {
    VStack{
        CommunityCard()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray900)
}
