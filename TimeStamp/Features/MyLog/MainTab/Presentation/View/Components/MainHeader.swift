//
//  MainHeader.swift
//  Stampic
//
//  Created by 임주희 on 1/22/26.
//

import SwiftUI

struct MainHeader: View {
    @Binding var selectedTab: Int
    let onClickProfile: () -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            logo
            
            Spacer()
            
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
                    .frame(width: 123, height: 26)
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
            onClickProfile()
        } label: {
            Image("iconUser_line")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 20)
        }
    }
}

#Preview {
    MainHeader(selectedTab: .constant(1), onClickProfile: {})
}
