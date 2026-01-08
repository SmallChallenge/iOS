//
//  Moody2Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Moody2Template: View , TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    var body: some View {
        ZStack() {
            VStack {
                if hasLogo {
                    LogotypeImage()
                        
                }
                
                Spacer()
                
                // 날짜
                Text(displayDate.toString(.yyyyMMdd))
                    .font(.suit(.bold), size: 20, trackingPercent: -0.02)
                    .foregroundColor(.gray50)
                    .shadow(
                        color: Color.black.opacity(0.45),
                        radius: 5, x: 0, y: 0
                    )
                    
            }
            .padding(16)
           
           
            
            // 원형 시계
            ZStack {
                Image("clearCircle")
                    .resizable()
                // Inner shadow (overlay로 구현)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            .blur(radius: 0.5) // Blur1 / 2
                            .offset(x: 1, y: -2)
                            .mask(Circle())
                            .frame(width: 240, height: 236)
                    )
                // Drop shadow 1
                    .shadow(
                        color: Color.black.opacity(0.25),
                        radius: 10, // Blur20 / 2
                        x: 0,
                        y: 4
                    )
                    .frame(width: 280, height: 280)

                // 시간 텍스트 (중앙 정렬)
                VStack(spacing: 0) {
                    // 시
                    Text(hourString)
                        .font(.suit(.extraLight), size: 100, trackingPercent: -0.02)
                        .offset(y: 20)
                        
                    // 분
                    Text(minuteString)
                        .font(.suit(.extraLight), size: 100, trackingPercent: -0.02)
                        .offset(y: -20)
                }
                .foregroundColor(.gray50)
                .shadow(
                    color: Color.black.opacity(0.3),
                    radius: 10 / 2, x: 0, y: 0
                )
            }
        }
    }
    
    private var hourString: String {
           let hour = Calendar.current.component(.hour, from: displayDate)
           return String(format: "%02d", hour)
       }
       
       private var minuteString: String {
           let minute = Calendar.current.component(.minute, from: displayDate)
           return String(format: "%02d", minute)
       }
}


#Preview {
    
    VStack{
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Moody2Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Moody2Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}

