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
                Text(displayDate.toString(.yyyyMMdd))
                    .font(.H3)
                    .foregroundColor(.gray50)

                Text(displayDate.toString(.time_HH_mm))
                    .font(.H1)
                    .foregroundColor(.gray50)
            }

            // 오른쪽 하단: 로고
            if hasLogo {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        LogotypeImage()
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
