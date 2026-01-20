//
//  Moody8Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Moody8Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Image("spring")
            Spacer()
            
            VStack(alignment: .center, spacing: .zero) {
                if hasLogo {
                    TimeStampWhiteLogo()
                }
                Text(displayDate.toString(.time_a_h_mm, locale: .kr))
                    .font(.bMKkubulim, size: 40)
                    
                Text(displayDate.toString(.yyyyMMdd_E, locale: .kr))
                    .font(.bMKkubulim, size: 18)
            }
            .foregroundStyle(Color.gray50)
            .shadow(
                color: Color.black.opacity(0.45),
                radius: 5/2, x: 0, y: 0
            )
            .padding(16)
        }
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Moody8Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Moody8Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
