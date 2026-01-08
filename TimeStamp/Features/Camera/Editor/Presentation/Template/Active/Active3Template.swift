//
//  Active3Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Active3Template: View ,TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    
    var body: some View {
        ZStack(alignment: .center) {
            
            HStack {
                Text(displayDate.toString(.edmmm))
                    .font(.pretendard(.medium), size: 14)
                
                Spacer()
               
                Text("TODAY DONE")
                    .font(.pretendard(.medium), size: 14)
                
            }
            .padding(16)
            
            
            VStack(alignment: .center, spacing: -35) {
                
                Spacer()
                Text(displayDate.toString(format: "HH"))
                    .font(.ericaOne, size: 70)
                
                Text(displayDate.toString(format: "mm"))
                    .font(.ericaOne, size: 70)
                Spacer()
            }
        }
        .foregroundStyle(.white)
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
        .overlay(alignment: .bottom) {
            if hasLogo {
                LogotypeImage()
                    .padding(16)
            }
        }
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Active3Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Active3Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
    
}
