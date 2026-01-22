//
//  HeaderView.swift
//  Stampic
//
//  Created by 임주희 on 1/22/26.
//

import SwiftUI

/*
 패딩 없음. 알아서 넣기!
 
 */
struct HeaderView<Leading: View, Trailing: View>: View {
    let leadingView: Leading?
    let title: String?
    let trailingView: Trailing?

    init(
        @ViewBuilder leadingView: () -> Leading,
        title: String? = nil,
        @ViewBuilder trailingView: () -> Trailing
    ) {
        self.leadingView = leadingView()
        self.title = title
        self.trailingView = trailingView()
    }

    var body: some View {
        ZStack {
            
            // 타이틀
            if let title = title {
                Text(title)
                    .font(.H3)
                    .foregroundStyle(Color.gray50)
            }
            
            // 양쪽 버튼
            HStack(alignment: .center, spacing: .zero) {
                leadingView
                
                Spacer()
                
                trailingView
            } // ~HStack
            
            
        } // ~ZStack
        .frame(height: 66)
        .border(.red)
    }
}

extension HeaderView where Leading == EmptyView {
    init(
        title: String? = nil,
        @ViewBuilder trailingView: () -> Trailing
    ) {
        self.leadingView = nil
        self.title = title
        self.trailingView = trailingView()
    }
}

extension HeaderView where Trailing == EmptyView {
    init(
        @ViewBuilder leadingView: () -> Leading,
        title: String? = nil
    ) {
        self.leadingView = leadingView()
        self.title = title
        self.trailingView = nil
    }
}

extension HeaderView where Leading == EmptyView, Trailing == EmptyView {
    init(title: String? = nil) {
        self.leadingView = nil
        self.title = title
        self.trailingView = nil
    }
}

#Preview {
    VStack(spacing: 20) {
        
        HeaderView(title: "타이틀")
            .background(Color.gray900)

        HeaderView(
            leadingView: {
                BackButton(action: {})
            },
            title: "리딩만"
        )
        .background(Color.gray900)

        HeaderView(
            title: "트레일링만",
            trailingView: {
                MainButton(title: "다음", size: .small) {}
                    .padding(.trailing, 20)
            }
        )
        .background(Color.gray900)
        
        
        HeaderView(
            leadingView: {
                BackButton(action: {})
            },
            title: "타이틀",
            trailingView: {
                MainButton(title: "다음", size: .small) {}
                    .padding(.trailing, 20)
            }
        )
        .background(Color.gray900)
        
    }
}
