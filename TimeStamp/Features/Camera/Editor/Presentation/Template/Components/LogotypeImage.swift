//
//  LogotypeImage.swift
//  TimeStamp
//
//  Created by 임주희 on 1/4/26.
//


import SwiftUI
struct LogotypeImage: View {
    var body: some View {
        Image("Logotype")
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(Color.gray50)
            .frame(width: 60, height: 13)
    }
}
