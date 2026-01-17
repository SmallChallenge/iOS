//
//  Moody4Template.swift
//  Stampic
//
//  Created by 임주희 on 1/4/26.
//

import SwiftUI

struct Moody4Template: View, TemplateViewProtocol {
    let displayDate: Date
    let hasLogo: Bool
    
    
    var body: some View {
        
        VStack(spacing: .zero) {
            
            Text(displayDate.toString(.time_a_h_mm, locale: .kr))
                .font(.bMKkubulim, size: 34)
                
            Text(displayDate.toString(.yyyyMMdd_E, locale: .kr))
                .font(.bMKkubulim, size: 18)
            
            Spacer()
            
           Text("\"수고했어 오늘도\"")
                .font(.bMKkubulim, size: 20)
            
        }
        .foregroundStyle(.gray50)
        .frame(maxWidth: .infinity)
        .overlay(alignment: .bottomTrailing) {
            if hasLogo {
                TimeStampWhiteLogo()
            }
        }
        .padding(.top, 24)
        .padding([.bottom, .horizontal], 16)
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
            
            Moody4Template(displayDate: Date(), hasLogo: true)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Moody4Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}


import UIKit


struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
