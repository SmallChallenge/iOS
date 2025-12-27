//
//  DefaultTemplateView2.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI
import Combine

struct DefaultTemplateView2: View {
    let hasLogo: Bool
    
    
    @State private var currentDate = Date()

    // 매초마다 업데이트되는 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // 중앙: 날짜 + 시계
            VStack(spacing: 8) {
                Text(formattedDate)
                    .font(.H3)
                    .foregroundColor(.gray50)

                Text(formattedTime)
                    .font(.H1)
                    .foregroundColor(.gray50)
            }

            // 오른쪽 하단: 로고
            if hasLogo {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("TemplateLogo_Stampy")
                            .resizable()
                            .frame(width: 100, height: 27)
                            .foregroundColor(.gray50)
                            .padding(16)
                    }
                }
            }
        }
        .onReceive(timer) { _ in
            currentDate = Date()
        }
    }

    // MARK: - Time Formatting

    /// 현재 날짜 문자열 (예: 2025.12.19)
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: currentDate)
    }

    /// 현재 시간 문자열 (예: 14:30:45)
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: currentDate)
    }
}

#Preview {
    DefaultTemplateView2(hasLogo: true)
}
