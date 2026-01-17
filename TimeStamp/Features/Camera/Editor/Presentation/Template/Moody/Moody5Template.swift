//
//  Moody5Template.swift
//  Stampic
//
//  Created by 임주희 on 1/17/26.
//

import SwiftUI

struct Moody5Template: View , TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { geo in
                let size = min(min(geo.size.width, geo.size.height) * 0.8, 400)

                ZStack(alignment: .center) {
                    Circle()
                        .strokeBorder(Color.gray50, lineWidth: 3)
                        .frame(width: size, height: size)

                    VStack(spacing: .zero) {
                        Text(displayDate.toString(.yyyyMMdd))
                            .font(.ownglyph, size: 24)

                        Text(displayDate.toString(.time_HH_mm))
                            .font(.ownglyph, size: 40)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .overlay(alignment: .bottomLeading, content: {
            if hasLogo {
                RoundedLogotype()
                    .padding(16)
                
            }
        })
        .foregroundStyle(Color.gray50)
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
            
            Moody5Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Moody5Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
