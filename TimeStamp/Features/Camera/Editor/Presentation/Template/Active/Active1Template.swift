//
//  Active1Template.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import SwiftUI

struct Active1Template: View, TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    
    
    var body: some View {
        ZStack(alignment: .center) {
            

            VStack(spacing: .zero) {
                Text(displayDate.toString(format: "HH:mm"))
                    .font(.climateCrisis(._1990), size: 50)
                    
                
                
                Text(displayDate.toString(format: "E, d MMM"))
                    .font(.climateCrisis(._1990), size: 15)
                
            }
            .foregroundStyle(Color.gray50)
            
            
        }
        .frame(maxHeight: .infinity)
        .overlay(alignment: .bottom, content: {
            if hasLogo {
                Image("Logotype")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(Color.gray50)
                    .frame(width: 60, height: 13)
                    .padding(.bottom, 16)
            }
        })
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5, x: 0, y: 0
        )
    }
}

#Preview {
    ZStack {
        Image("sampleImage")
            .resizable()
            .frame(width: 300, height: 300)
            .aspectRatio(1, contentMode: .fit)
        
        Active1Template(displayDate: Date(), hasLogo: true)
    }
    .frame(width: 300, height: 300)
    .aspectRatio(1, contentMode: .fit)
}
