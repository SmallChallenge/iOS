//
//  Basic5Template.swift
//  Stampic
//
//  Created by 임주희 on 1/17/26.
//

import SwiftUI

struct Basic5Template: View,  TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(displayDate.toString(format: "EEEE,"))
                    .font(.pretendard(.bold), size: 16)
                Text(displayDate.toString(format: "d MMM"))
                    .font(.pretendard(.medium), size: 16)
                Spacer()
                Text(displayDate.toString(.time_HH_mm))
                    .font(.pretendard(.medium), size: 16)
                Spacer()
                if hasLogo {
                    LogotypeImage()
                }
            }
            .foregroundStyle(Color.gray50)
            .padding(16)
            .background(
                    LinearGradient(
                        colors: [.black.opacity(0.2), .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            Spacer()
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
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Basic5Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Basic5Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}
