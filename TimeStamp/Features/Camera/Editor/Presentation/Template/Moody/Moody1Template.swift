//
//  Moody1Template.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import SwiftUI

struct Moody1Template: View, TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    
    
    var body: some View {
        VStack{
            VStack(spacing: .zero) {
                Text(displayDate.toString(.edmmm )) //"E, d MMM"
                    .font(.moveSans(.bold), size: 30, trackingPercent: -0.02)
                    .foregroundStyle(Color.gray50)
                    
                
                Text(displayDate.toString(.time_a_hh_mm)) //"a hh:mm"
                    .font(.moveSans(.bold), size: 16, trackingPercent: -0.02)
                    .foregroundStyle(Color.gray50)
                    
            }
            .padding(.top, 16)
            
            Spacer()
            
            if hasLogo {
                LogotypeImage()
                    .padding(16)
            }
        }
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Moody1Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Moody1Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}
