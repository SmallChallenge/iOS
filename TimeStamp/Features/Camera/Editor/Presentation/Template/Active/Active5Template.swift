//
//  Active5Template.swift
//  Stampic
//
//  Created by 임주희 on 1/17/26.
//

import SwiftUI

struct Active5Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Text("JUST DO IT")
                .font(.partialSans, size: 14, trackingPercent: 0.1)
            Spacer()
            
            Text(displayDate.toString(.yyyyMMdd_E))
                .font(.partialSans, size: 14)
            
            Text(displayDate.toString(.time_a_h_mm))
                .font(.partialSans, size: 24)
        }
        .padding(.top, 14)
        .padding(.bottom, 24)
        .foregroundStyle(Color.gray50)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
        .overlay(alignment: .topTrailing, content: {
            if hasLogo {
                LogotypeImage()
                    .padding(16)
                
            }
        })
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
            
            Active5Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Active5Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
