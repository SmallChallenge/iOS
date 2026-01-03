//
//  Digital1Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Digital1Template: View, TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    
    
    var body: some View {
        VStack {
            if hasLogo {
                LogotypeImage()
                    .padding(16)
            }
            
            Spacer()
                .frame(height: 41)
            
            HStack(spacing: 6) {
                // 시 (10의 자리)
                FlipDigitView(digit: hourTens)
                // 시 (1의 자리)
                FlipDigitView(digit: hourOnes)
                
                // 콜론
                Text(":")
                    .font(.suit(.heavy), size: 53.6)
                    .foregroundColor(.white)
                
                // 분 (10의 자리)
                FlipDigitView(digit: minuteTens)
                // 분 (1의 자리)
                FlipDigitView(digit: minuteOnes)
            }
            
            Spacer()
            
            Text(displayDate.toString(.yyyyMMdd))
                .font(.suit(.heavy),size: 24, trackingPercent: -0.02)
                .foregroundColor(.gray50)
                .shadow(
                    color: Color.black.opacity(0.45),
                    radius: 5/2, x: 0, y: 0
                )
                .padding(.bottom, 16)
            
        }
    }
    
    private var hourTens: Int {
        Calendar.current.component(.hour, from: displayDate) / 10
    }
    
    private var hourOnes: Int {
        Calendar.current.component(.hour, from: displayDate) % 10
    }
    
    private var minuteTens: Int {
        Calendar.current.component(.minute, from: displayDate) / 10
    }
    
    private var minuteOnes: Int {
        Calendar.current.component(.minute, from: displayDate) % 10
    }
    
}

#Preview {
    ZStack {
//        Image("sampleImage")
//            .resizable()
//            .frame(width: 300, height: 300)
//            .aspectRatio(1, contentMode: .fit)
//        Color.gray400
        
        Digital1Template(displayDate: Date(), hasLogo: true)
    }
    .frame(width: 300, height: 300)
    .aspectRatio(1, contentMode: .fit)
}


struct FlipDigitView: View {
    let digit: Int
    
    var body: some View {
        ZStack {
            // 배경 + 블러
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Color.white.opacity(0.2))
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.white.opacity(0.2))
                        .blur(radius: 6)
                )
                .frame(width: 45, height: 60)
            // Inner shadow
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                        .blur(radius: 1)
                        .offset(x: 1, y: 1)
                )
            // Drop shadow
                .shadow(
                    color: Color.black.opacity(0.4),
                    radius: 10,
                    x: 3,
                    y: 3
                )
            
            Text("\(digit)")
                .font(.suit(.extraBold), size: 50, trackingPercent: -0.02)
                .foregroundStyle(Color.gray50)
        }
    }
}

