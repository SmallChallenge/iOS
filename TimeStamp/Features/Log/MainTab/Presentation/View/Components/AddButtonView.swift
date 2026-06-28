//
//  AddButtonView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct AddButtonView: View {
    var body: some View {
        Color.neon300
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 28.0))
            .overlay {
                Image("IconAdd")
                    .renderingMode(.template)
                    .foregroundStyle(.gray900)
            }
    }
}

#Preview {
    AddButtonView()
}
