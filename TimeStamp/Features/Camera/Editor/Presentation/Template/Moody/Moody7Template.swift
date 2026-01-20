//
//  Moody7Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Moody7Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Spacer()
            
            Group {
                Text(displayDate.toString(.yyyyMMdd))
                Text(displayDate.toString(.time_a_hh_mm))
            }
            .font(.notable, size: 20)
            .foregroundStyle(Color.gray50)
            
            
            Spacer()
        }
        .overlay(alignment: .bottom, content: {
            if hasLogo {
                LogotypeImage()
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
            
            Moody7Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Moody7Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
