//
//  Digital3Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Digital3Template: View  ,TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    
    
    var body: some View {
        VStack (alignment: .leading, spacing: 0){
            HStack {
                Spacer()
                if hasLogo {
                    LogotypeImage()
                        .padding(16)
                }
            }
            Spacer()
            
            Text(displayDate.toString(.krDate_yyyyMM월dd일E, locale: .kr))
                .font(.dungGeunMo, size: 28)
            Text(displayDate.toString(.time_a_HH_mm, locale: .kr))
                .font(.dungGeunMo, size: 28)
            
            
        }
        .foregroundStyle(Color.white)
        .padding([.leading, .bottom],24)
    }
}

#Preview {
    VStack {
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Digital3Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Digital3Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}
