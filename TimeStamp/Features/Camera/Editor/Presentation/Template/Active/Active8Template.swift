//
//  Active8Template.swift
//  Stampic
//
//  Created by 임주희 on 1/20/26.
//

import SwiftUI

struct Active8Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack {
                Spacer()
                if hasLogo {
                    LogotypeImage()
                }
            }
            Spacer()
            
            Text(displayDate.toString(format: "yyyy년\nMM월 dd일 (E)\na h:mm", locale: .kr))
                .font(.rixInooAriDuri, size: 18)
                .multilineTextAlignment(.leading)
                .lineSpacing(18 * 0.3)
                .foregroundStyle(Color.white)
        }
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
            Active8Template(displayDate: Date(), hasLogo: true)
        }
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
            Active8Template(displayDate: Date(), hasLogo: false)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}
