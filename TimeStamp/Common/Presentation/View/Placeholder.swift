//
//  Placeholder.swift
//  TimeStamp
//
//  Created by 임주희 on 12/30/25.
//

import SwiftUI

struct Placeholder: View {
    let width: CGFloat
    let height: CGFloat
    init(width: CGFloat = 24, height: CGFloat = 24) {
        self.width = width
        self.height = height
    }
    var body: some View {
        ZStack(alignment: .center) {
            
            Color.gray800
                
            Image("IconPic")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.gray600)
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    Placeholder()
}
