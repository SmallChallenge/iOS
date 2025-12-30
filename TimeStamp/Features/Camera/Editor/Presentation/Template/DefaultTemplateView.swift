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
                Text(displayDate.toString(format: "yyyy.MM.dd"))
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.gray50)

                Text(displayDate.toString(format: "HH:mm"))
                    .font(.system(size: 48, weight: .bold))
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
    DefaultTemplateView(displayDate: Date(), hasLogo: true)
    .background(Color.black)
}
