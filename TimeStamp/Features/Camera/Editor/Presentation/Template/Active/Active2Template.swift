//
//  Active2Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Active2Template: View ,TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    var body: some View {
        
        VStack {
            
            if hasLogo {
                LogotypeImage()
                    .padding(16)
            }
            
            Spacer()
            
            VStack (spacing: 4){
                Text(displayDate.toString(.time_HH_mm_a))
                    .font(.partialSans, size: 28)
                    .foregroundColor(.gray50)
                
                Text(dateString)
                    .font(.partialSans, size: 18)
                    .foregroundColor(.gray50)
            }
            .shadow(
                color: Color.black.opacity(0.45),
                radius: 5/2, x: 0, y: 0
            )
            .padding(24)
            
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
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Active2Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Active2Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}
