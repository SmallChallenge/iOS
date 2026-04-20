//
//  Digital7Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Digital7Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero){
            
            ZStack {
                
                // 텍스트 외곽선 효과 (상하좌우 1px 이동)
                ForEach(Array(strokeOffsets.enumerated()), id: \.offset) { _, offset in
                    dateTimeText
                        .foregroundStyle(Color.black)
                        .offset(x: offset.x, y: offset.y)
                }
                
                // 메인 텍스트
                dateTimeText
                    .foregroundStyle(Color.gray50)
                    .shadow(
                        color: Color.black.opacity(0.45),
                        radius: 5/2, x: 0, y: 0
                    )
                
            }
            .padding(24)
            
            Spacer()
            HStack {
                Spacer ()
                if hasLogo {
                    LogotypeImage()
                        .shadow(
                            color: Color.black.opacity(0.45),
                            radius: 5/2, x: 0, y: 0
                        )
                        .padding(16)
                }
            }
        }
    }
    
    private var dateTimeText: some View {
        VStack(alignment: .leading, spacing: .zero){
            Text(dateString)
                .font(.dungGeunMo(.bold), size: 18)
            
            Text(displayDate.toString(.time_h_mm_a))
                .font(.dungGeunMo(.bold), size: 28)
        }
    }
    
    private var dateString: String {
        let day = Calendar.current.component(.day, from: displayDate)
        let year = Calendar.current.component(.year, from: displayDate)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "MMMM"
        let month = formatter.string(from: displayDate)
        
        let suffix = daySuffix(for: day)
        
        return "\(month) \(day)\(suffix) \(year)"
    }

    private func daySuffix(for day: Int) -> String {
        let lastDigit = day % 10
        let lastTwoDigits = day % 100
        
        if (11...13).contains(lastTwoDigits) {
            return "th"
        }
        
        switch lastDigit {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }
    
    private var strokeOffsets: [(x: CGFloat, y: CGFloat)] {
        [
            (x: 1.5, y: 0),
            (x: -1.5, y: 0),
            (x: 0, y: 1.5),
            (x: 0, y: -1.5)
        ]
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Digital7Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Digital7Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
