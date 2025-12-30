//
//  HeaderView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct HeaderView: View {
    let onProfileTap: () -> Void
    
    var body: some View {
        HStack (alignment: .center){
            Image("MainAppName")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.gray50)
                .frame(width: 122.8, height: 26)
                .padding(.vertical, 17)
                .padding(.leading, 20)
            
            Spacer()
            
            // 프로필 버튼
            Button {
                onProfileTap()
            } label: {
                Image("iconUser_line")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 20)
            }
        }
        .frame(height: 60)
        
    }
}

#Preview {
    HeaderView(onProfileTap: {})
}
