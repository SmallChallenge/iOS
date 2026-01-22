//
//  HeaderView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct MainHeaderView: View {
    @Binding var selectedTab: Int
    let onProfileTap: () -> Void
    
    var body: some View {
        HStack (alignment: .center, spacing: .zero){
            
            // 로고
            logo
           
            
            Spacer()
            
            // 프로필 버튼
            profillButton
        }
        .frame(height: 60)
        
    }
    private var logo: some View {
        Group {
            if selectedTab == 0 {
                Image("Logotype")
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(Color.gray50)
                    .frame(width: 122.8, height: 26)
                    .padding(.leading, 20)
            } else {
                Text("커뮤니티")
                    .font(.H2)
                    .foregroundStyle(Color.gray50)
                    .padding(.leading, 20)
            }
        }
    }
    
    
    private var profillButton: some View {
        Button {
            onProfileTap()
        } label: {
            Image("iconUser_line")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 20)
        }
    }
}

#Preview {
    MainHeaderView(selectedTab: .constant(0), onProfileTap: {})
        .background(Color.gray900)
}
