//
//  Digital6Template.swift
//  Stampic
//
//  Created by 임주희 on 1/19/26.
//

import SwiftUI

struct Digital6Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool

    var body: some View {
        VStack {
            
            Spacer()
            
            ZStack (alignment: .center){
                // 텍스트 외곽선 효과 (상하좌우 1px 이동)
                ForEach(Array(strokeOffsets.enumerated()), id: \.offset) { _, offset in
                    dateTimeText
                        .foregroundStyle(Color.black)
                        .offset(x: offset.x, y: offset.y)
                }
                
                // 메인 텍스트
                dateTimeText
                    .foregroundStyle(Color(hex: "FFDD00"))
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing, content: {
            if hasLogo {
                TimeStampLogo()
            }
        })
        .padding(16)
    }
    
    private var dateTimeText: some View {
        Group {
            Text(displayDate.toString(.koreanDate_yyMM월dd일E))
            + Text(", ")
            + Text(displayDate.toString(.time_a_h_mm))
        }
        .font(.dungGeunMo, size: 16, trackingPercent: -0.02)
    }
    
    
    private var strokeOffsets: [(x: CGFloat, y: CGFloat)] {
        [
            (x: 1, y: 0),
            (x: -1, y: 0),
            (x: 0, y: 1),
            (x: 0, y: -1)
        ]
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Digital6Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Digital6Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
