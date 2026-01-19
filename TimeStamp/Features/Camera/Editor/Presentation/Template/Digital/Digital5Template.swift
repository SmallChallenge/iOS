//
//  Digital5Template.swift
//  Stampic
//
//  Created by 임주희 on 1/19/26.
//

import SwiftUI

struct Digital5Template: View ,TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool

    private var dateTimeText: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text(displayDate.toString(.yyyyMMdd))
                .font(.cafe24PROUP, size: 20)
            Text(displayDate.toString(.time_a_hh_mm).lowercased())
                .font(.cafe24PROUP, size: 20)
        }
    }

    var body: some View {
        ZStack (alignment: .topLeading){
            // 텍스트 외곽선 효과 (상하좌우 1px 이동)
            ForEach(Array(strokeOffsets.enumerated()), id: \.offset) { _, offset in
                dateTimeText
                    .foregroundStyle(Color.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .offset(x: offset.x, y: offset.y)
            }

            // 메인 텍스트
            dateTimeText
                .foregroundStyle(Color.gray50)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .overlay(alignment: .bottomTrailing, content: {
            if hasLogo {
                BordedRoundedLogotype()
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        
    }

    private var strokeOffsets: [(x: CGFloat, y: CGFloat)] {
        [
            (x: 1.2, y: 0),
            (x: -1.2, y: 0),
            (x: 0, y: 1.2),
            (x: 0, y: -1.2)
        ]
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Digital5Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Digital5Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
