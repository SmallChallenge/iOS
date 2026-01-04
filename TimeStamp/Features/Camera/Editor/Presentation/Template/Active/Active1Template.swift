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
                Text(displayDate.toString(.time_HH_mm ))
                    .font(.climateCrisis, size: 50)
                    
                
                
                Text(displayDate.toString(.edmmm)) //"E, d MMM"
                    .font(.climateCrisis, size: 15)
                
            }
            .foregroundStyle(Color.gray50)
            
            
        }
        .frame(maxHeight: .infinity)
        .overlay(alignment: .bottom, content: {
            if hasLogo {
                LogotypeImage()
            }
        })
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
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
