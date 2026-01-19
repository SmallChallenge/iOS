//
//  Basic6Template.swift
//  Stampic
//
//  Created by 임주희 on 1/19/26.
//

import SwiftUI

struct Basic6Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        HStack(alignment: .bottom, spacing: .zero) {
            VStack(alignment: .leading, spacing: .zero) {
                Spacer()
                
                Text(displayDate.toString(.edmmm))
                    .font(.lineSeedKR(.bold), size: 30, trackingPercent: -0.02)
                Text(displayDate.toString(.time_a_HH_mm).lowercased())
                    .font(.lineSeedKR(.bold), size: 16, trackingPercent: -0.02)
                    
            }
            .foregroundStyle(Color.gray50)
            .shadow(
                color: Color.black.opacity(0.45),
                radius: 5/2, x: 0, y: 0
            )

            Spacer()
            
            if hasLogo {
                TimeStampWhiteLogo()
            }
        }
        .padding(16)
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Basic6Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Basic6Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
