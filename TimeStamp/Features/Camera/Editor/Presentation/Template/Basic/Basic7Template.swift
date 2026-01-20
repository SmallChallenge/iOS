//
//  Basic7Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Basic7Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack {
            if hasLogo {
                LogotypeImage()
            }
            
            Spacer()
            
            Text(displayDate.toString(.yyyyMMddahhmm).lowercased())
                .font(.spaceMono(.boldItalic), size: 16)
                .foregroundStyle(Color.gray50)
        }
        .padding(16)
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
            
            Basic7Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Basic7Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
