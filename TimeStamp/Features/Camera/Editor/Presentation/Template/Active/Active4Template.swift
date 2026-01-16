//
//  Active4Template.swift
//  Stampic
//
//  Created by 임주희 on 1/16/26.
//

import SwiftUI

struct Active4Template: View ,TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: 6) {
            
            Text(displayDate.toString(.time_a_h_mm, locale: .kr))
                .font(.partialSans, size: 28)
            
            Text(displayDate.toString(.yyyyMMdd_E, locale: .kr))
                .font(.partialSans, size: 12)
                
            
            Spacer()
            
            if hasLogo {
                TimeStampWhiteLogo()
            }

        }
        .foregroundStyle(Color.gray50)
        .padding(.top, 24)
        .padding(.bottom, 16)
        
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
        .foregroundStyle(Color.gray50)
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Active4Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Active4Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}
