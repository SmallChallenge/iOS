//
//  DefaultTemplateView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/19/25.
//

import SwiftUI
import Combine


/// 기본 타임스탬프 템플릿 뷰
struct DefaultTemplateView: View {
    let hasLogo: Bool
    
    
    @State private var currentDate = Date()

    // 매초마다 업데이트되는 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            // 중앙: 날짜 + 시계
            VStack(spacing: 8) {
                Text(formattedDate)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.gray50)

                Text(formattedTime)
                    .font(.system(size: 48, weight: .bold))
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
    DefaultTemplateView(hasLogo: true)
        .background(Color.black)
}
