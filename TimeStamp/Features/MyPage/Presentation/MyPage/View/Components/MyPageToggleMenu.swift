//
//  MyPageToggleMenu.swift
//  Stampic
//
//  Created by 임주희 on 5/11/26.
//

import SwiftUI

struct MyPageToggleMenu: View {
    let title: String
    @Binding var toggleValue: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.Btn2_b)
                .foregroundStyle(Color.gray300)
            
            Spacer()
            
            Toggle(isOn: $toggleValue) {}
            .padding(.trailing, 20)
            
        }
        .padding(.leading, 20)
        .padding(.vertical, 19.5)
    }
}

#Preview {
    MyPageToggleMenu(title: "갤러리에 자동 저장", toggleValue: .constant(true))
}
