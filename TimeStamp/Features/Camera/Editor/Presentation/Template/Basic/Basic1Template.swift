//
//  Basic1Template.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import SwiftUI

struct Basic1Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            // "HH:mm"
            Text(displayDate.toString(.time_HH_mm))
                .font(.pretendard(.medium), size: 55, trackingPercent: -0.02)
                .foregroundStyle(Color.gray50)
                .padding(.top, 24)
            
            
            
            Text("\(displayDate.toString(.yyyyMMdd)) • Stampic")
                .font(.pretendard(.medium), size: 15, trackingPercent: -0.02)
                .foregroundStyle(Color.gray50)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
        .overlay(alignment: .bottomTrailing, content: {
            if hasLogo {
                TimeStampLogo()
                    .padding(16)
            }
        })
    }
}


#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Basic1Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Basic1Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
    
}
