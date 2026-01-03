//
//  DefaultTemplateView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/19/25.
//

import SwiftUI


/// 기본 타임스탬프 템플릿 뷰
struct DefaultTemplateView: TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        ZStack {
            // 중앙: 날짜 + 시계
            VStack(spacing: 8) {
                Text(displayDate.toString(.yyyyMMdd))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.gray50)

                Text(displayDate.toString(.time_HH_mm))
                    .font(.system(size: 48, weight: .bold))
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
    DefaultTemplateView(displayDate: Date(), hasLogo: true)
    .background(Color.black)
}
