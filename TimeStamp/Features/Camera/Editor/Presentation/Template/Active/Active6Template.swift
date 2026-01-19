//
//  Active6Template.swift
//  Stampic
//
//  Created by 임주희 on 1/19/26.
//

import SwiftUI

struct Active6Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            
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
                
            
            Spacer()
            
            
            
            ZStack {
                // 텍스트 외곽선 효과 (상하좌우 1px 이동)
                ForEach(Array(strokeOffsets.enumerated()), id: \.offset) { _, offset in
                    Text("오늘도 해냈다!")
                        .font(.keriskedu(.bold), size: 20)
                        .foregroundStyle(Color.black)
                        .offset(x: offset.x, y: offset.y)
                }

                // 메인 텍스트
                
                Text("오늘도 해냈다!")
                    .font(.keriskedu(.bold), size: 20)
                    .shadow(
                        color: Color.black.opacity(0.45),
                        radius: 5/2, x: 0, y: 0
                    )
            }
            
           
        }
        .foregroundStyle(Color.gray50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: .topTrailing) {
            if hasLogo {
                TimeStampLogo()
            }
        }
        .padding(16)
    }
    
    private var dateTimeText: some View {
        VStack(alignment: .center, spacing: .zero) {
            Text(displayDate.toString(.yyyyMMdd_E))
                .font(.keriskedu(.bold), size: 16)
            Text(displayDate.toString(.time_a_h_mm))
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
            Active6Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Active6Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
