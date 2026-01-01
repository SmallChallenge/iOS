//
//  NoticeBanner.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//


import SwiftUI

struct NoticeBanner: View {
    let content: String
    init(_ content: String) {
        self.content = content
    }
    var body: some View {
        HStack (alignment: .center, spacing: 6){
            Image(systemName: "exclamationmark.circle.fill")
            Text(content)
                .font(.Body2)
            
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.gray500)
        .background(Color.gray800)
        .rounded(radius: 8)
    }
}
