//
//  Digital8Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Digital8Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack {
            
            Group {
                Text(displayDate.toString(.krDate_yyyyMM월dd일E, locale: .kr))
                    .font(.galmuriMono11, size: 20)
                Text(displayDate.toString(.time_ah_mm, locale: .kr))
                    .font(.galmuriMono11, size: 20)
            }
            .foregroundStyle(Color.gray50)
            
            Spacer()
            
            Ellipse()
                .fill(Color.white)
                .blur(radius: 5)
                .frame(width: 220, height: 40)
                .overlay(alignment: .center) {
                    Text("경험치가 +1% 상승했습니다.")
                        .font(.galmuriMono11, size: 12)
                        .foregroundStyle(Color.black)
                }
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .topTrailing) {
            if hasLogo {
                LogotypeImage()
            }
        }
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
        .padding(16)
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Digital8Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Digital8Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
