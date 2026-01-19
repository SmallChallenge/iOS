//
//  Moody6Template.swift
//  Stampic
//
//  Created by 임주희 on 1/19/26.
//

import SwiftUI

struct Moody6Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            HStack {
                Spacer()
                
                if hasLogo {
                    TimeStampWhiteLogo()
                }
            }
            
            Spacer()
            
            Group {
                Text(displayDate.toString(.yyyyMMdd))
                    .font(.monofett, size: 25)
                Text(displayDate.toString(.time_HH_mm))
                    .font(.monofett, size: 25)
            }
            .shadow(
                color: Color.black.opacity(0.45),
                radius: 5/2, x: 0, y: 0
            )
        }
        .foregroundStyle(Color.gray50)
        .padding(16)
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Moody6Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Moody6Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
