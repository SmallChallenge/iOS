//
//  Basic3Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Basic3Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: .zero){
                
                Text(displayDate.toString(.time_a_HH_mm, locale: .kr))
                
                    .font(.suit(.heavy), size: 40, trackingPercent: -0.02)
                
                
                Text(displayDate.toString(.koreanDate_yyyyMM월dd일E
                                          , locale: .kr))
                .font(.suit(.heavy), size: 20, trackingPercent: -0.02)
                
            }
            .foregroundStyle(Color.gray50)
            Spacer()
        }
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
        .overlay(alignment: .bottom) {
            if hasLogo {
                LogotypeImage()
                    .padding(16)
            }
        }
    }
}

#Preview {
    ZStack {
        Image("sampleImage")
            .resizable()
            .frame(width: 300, height: 300)
            .aspectRatio(1, contentMode: .fit)
        
        Basic3Template(displayDate: Date(), hasLogo: true)
    }
    .frame(width: 300, height: 300)
    .aspectRatio(1, contentMode: .fit)
}


