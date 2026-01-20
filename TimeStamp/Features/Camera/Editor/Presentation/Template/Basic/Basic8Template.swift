//
//  Basic8Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Basic8Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .trailing, spacing: .zero) {
                Text(displayDate.toString(.yyMMdd))
                    .font(.montserrat(.semiBold), size: 40)
                
                Text(displayDate.toString(.time_a_h_mm).lowercased())
                    .font(.montserrat(.semiBold), size: 20)
                    
                
                Spacer()
                
                if hasLogo {
                    LogotypeImage()
                }
            }
            .padding(16)
            .foregroundStyle(Color.gray50)
            
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
            
            Basic8Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Basic8Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
