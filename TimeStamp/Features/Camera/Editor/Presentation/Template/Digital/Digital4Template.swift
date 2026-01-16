//
//  Digital4Template.swift
//  Stampic
//
//  Created by 임주희 on 1/16/26.
//

import SwiftUI

struct Digital4Template: View ,TemplateViewProtocol {
    
    let displayDate: Date
    let hasLogo: Bool
    var body: some View {
        
        Color.clear
            .overlay(alignment: .topLeading) {
                topLeading
            }
            .overlay(alignment: .topTrailing) {
                topTrailing
            }
            .overlay(alignment: .bottomLeading) {
                bottomLeading
            }
            .overlay(alignment: .bottomTrailing) {
                bottomTrailing
            }
    }
    
    private var topLeading: some View {
        HStack(alignment: .center, spacing: 8) {
            Circle()
                .fill(Color(hex: "FF0000"))
                .frame(width: 14, height: 14)
            
            Text("REC")
                .font(.suit(.heavy), size: 16)
                .foregroundStyle(Color.gray50)
                .shadow(
                    color: Color.black.opacity(0.45),
                    radius: 5/2, x: 0, y: 0
                )
                
        }
        .padding(16)
        .background(alignment: .topLeading){
            Image("topleadingline")
                .shadow(
                    color: Color.black.opacity(0.45),
                    radius: 5/2, x: 0, y: 0
                )
        }
        .padding(16)
    }
    
    private var topTrailing: some View {
        HStack(alignment: .center, spacing: 8) {
            Image("hd")
                .resizable()
                .frame(width: 25, height: 16)
            
            Image("battery")
                .resizable()
                .foregroundStyle(Color.gray50)
                .frame(width: 29.33, height: 16)
        }
        .padding(16)
        .background(alignment: .topTrailing){
            Image("toptrailingline")
        }
        .padding(16)
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
    }
    
    private var bottomLeading: some View {
        VStack(alignment: .leading, spacing: -6) {
            Text(displayDate.toString(.yyyyMMdd))
                .font(.suit(.extraBold), size: 20, trackingPercent: -0.02)
            
            Text(displayDate.toString(.time_a_h_mm).lowercased())
                .font(.suit(.heavy), size: 32, trackingPercent: -0.02)
        }
        .foregroundStyle(Color.gray50)
        .padding(16)
        .background(alignment: .bottomLeading){
            Image("bottomleadingline")
        }
        .padding(16)
        .shadow(
            color: Color.black.opacity(0.45),
            radius: 5/2, x: 0, y: 0
        )
    }
    private var bottomTrailing: some View {
        VStack{
            if hasLogo {
                LogotypeImage()
            }
        }
        .padding(16)
        .background(alignment: .bottomTrailing){
            Image("bottomtrailingline")
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
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Digital4Template(displayDate: Date(), hasLogo: true)
        }
        
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
        
        ZStack {
            Image("sampleImage")
                .resizable()
                .frame(width: 300, height: 300)
                .aspectRatio(1, contentMode: .fit)
            
            Digital4Template(displayDate: Date(), hasLogo: false)
        }
        .frame(width: 300, height: 300)
        .aspectRatio(1, contentMode: .fit)
    }
}
