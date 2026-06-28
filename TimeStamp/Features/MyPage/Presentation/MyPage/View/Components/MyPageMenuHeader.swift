//
//  MyPageMenuHeader.swift
//  Stampic
//
//  Created by 임주희 on 5/11/26.
//

import SwiftUI

struct MyPageMenuHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.Label)
            .foregroundStyle(Color.gray500)
            .padding([.top, .leading], 20)
    }
}

#Preview {
    MyPageMenuHeader(title: "카메라 설정")
}
