//
//  ChevronRight.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//


import SwiftUI

struct ChevronRight: View {
    
    var body: some View {
        Rectangle()
            .foregroundStyle(Color.clear)
            .frame(width: 24, height: 24)
            .overlay(alignment: .center) {
                Image(systemName: "chevron.right")
            }
            .contentShape(Rectangle())
    }
}

#Preview {
    ChevronRight()
        .foregroundStyle(Color.red)
        
}
