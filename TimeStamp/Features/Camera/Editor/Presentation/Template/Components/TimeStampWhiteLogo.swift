//
//  TimeStampWhiteLogo.swift
//  TimeStamp
//
//  Created by 임주희 on 1/16/26.
//

import SwiftUI

struct TimeStampWhiteLogo: View {
    var body: some View {
        Image("logo_white")
            .resizable()
            .frame(width: 30, height: 30)
            .padding(8)
    }
}

struct TimeStampLogo: View {
    var body: some View {
        Image("logo_normal")
            .resizable()
            .frame(width: 38, height: 38)
    }
}
