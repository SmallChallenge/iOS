//
//  DefaultTemplateView2.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI

struct DefaultTemplateView2: TemplateViewProtocol{
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        ZStack {
            // 중앙: 날짜 + 시계
            VStack(spacing: 8) {
                Text(displayDate.toString(format: "yyyy.MM.dd"))
                    .font(.H3)
                    .foregroundColor(.gray50)

                Text(displayDate.toString(format: "HH:mm"))
                    .font(.H1)
                    .foregroundColor(.gray50)
            }

            // 오른쪽 하단: 로고
            if hasLogo {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("Logotype")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 122.8, height: 26)
                            .foregroundColor(.gray50)
                            .padding(16)
                    }
                }
            }
        }
    }
}

#Preview {
    DefaultTemplateView2(displayDate: Date(), hasLogo: true)
        .background(Color.gray900)
}
