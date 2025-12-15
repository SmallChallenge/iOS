//
//  CameraView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("CameraView")
            
            
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 20))
                        .foregroundStyle(.black)
                        .frame(width: 44, height: 44)
                }
                
                Spacer()
            }
            .padding()
            
            Spacer()
            
        }
    }
}

#Preview {
    CameraView()
}
