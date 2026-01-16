//
//  Basic4Template.swift
//  Stampic
//
//  Created by 임주희 on 1/16/26.
//

import SwiftUI

struct Basic4Template: View, TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack (alignment: .center, spacing: -2){
            Spacer()
            Text(displayDate.toString(.yyyy年M月d日))
                .font(.shipporiMincho(.bold), size: 20)
                .foregroundStyle(Color.gray50)
            
            Text(displayDate.toString(.time_h_m_a).lowercased())
                .font(.shipporiMincho(.bold), size: 16)
                .foregroundStyle(Color.gray50)
        }
        .frame(maxWidth: .infinity)
        .overlay(alignment: .topTrailing, content: {
            if hasLogo {
                TimeStampWhiteLogo()
            }
        })
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
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Basic4Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Basic4Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}


