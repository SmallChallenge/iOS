//
//  Active7Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Active7Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        ZStack (alignment: .center){
            ZStack (alignment: .center){
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .bottomTrailing) {
            if hasLogo {
                TimeStampLogo()
                    .padding(16)
            }
        }
    }
    
    private var dateTimeText: some View {
        VStack(alignment: .center, spacing: .zero) {
            Text(displayDate.toString(.time_a_h_mm, locale: .kr))
                .font(.keriskedu(.bold), size: 24)
            
            Text(displayDate.toString(.yyyyMMdd_E, locale: .kr))
                .font(.keriskedu(.bold), size: 16)
            
        }
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
            Active7Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Active7Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
