//
//  Moody3Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Moody3Template: View , TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        VStack(spacing: .zero){
            Color.gray50
                .frame(height: 10)
            
            HStack (alignment: .top, spacing: .zero){
                Color.gray50
                    .frame(width: 10)
                
                Spacer()
                
                if hasLogo {
                    LogotypeImage()
                        .padding(16)
                }
                
                Color.gray50
                    .frame(width: 10)
            }
            
            HStack(alignment: .bottom){
                Text(displayDate.toString(.time_a_HH_mm))
                    .font(.partialSans, size: 30)
                Spacer()
                
                Text(displayDate.toString(.yyyyMMddE, locale: .kr))
            }
            .padding(.top, 7)
            .padding([.horizontal, .bottom], 16)
            .background(Color.gray50)
        }
    }
}

#Preview {
    ZStack {
        Image("sampleImage")
            .resizable()
            .frame(width: 300, height: 300)
            .aspectRatio(1, contentMode: .fit)
        
        Moody3Template(displayDate: Date(), hasLogo: true)
    }
    .frame(width: 300, height: 300)
    .aspectRatio(1, contentMode: .fit)
}
