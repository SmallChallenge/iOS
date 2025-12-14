//
//  HeaderView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack (alignment: .center){
            Image("MainAppName")
                .resizable()
                .frame(width: 108, height: 40)
                .padding(.vertical, 10)
                .padding(.leading, 20)
            
            Spacer()
            
            Image("iconUser_line")
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 20)
        }
        .frame(height: 60)
        
    }
}

#Preview {
    HeaderView()
}
