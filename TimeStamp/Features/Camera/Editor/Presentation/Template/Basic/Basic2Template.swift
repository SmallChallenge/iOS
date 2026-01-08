//
//  Basic2Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Basic2Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
    
        VStack {
            Spacer()
            HStack {
                Text(displayDate.toString(
                    format: "\(Date.DateFormat.koreanDate_yyyyM월d일E.rawValue)\n\(Date.DateFormat.time_a_h_mm.rawValue)",
                    locale: .kr))
                .font(.suit(.heavy), size: 24, trackingPercent: -0.02)
                .multilineTextAlignment(.leading)
                .foregroundStyle(Color.gray50)
                .padding(24)
                
                Spacer()
            }
            .shadow(
                color: Color.black.opacity(0.45),
                radius: 5/2, x: 0, y: 0
            )
        }
        .overlay(alignment: .topTrailing) {
            if hasLogo {
                Image("logo_white")
                    .resizable()
                    .frame(width: 38, height: 38)
                    .padding(16)
            }
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
            
            Basic2Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Basic2Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}
