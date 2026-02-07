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
    let hasUnderLine: Bool

    init(
        @ViewBuilder leadingView: () -> Leading,
        title: String? = nil,
        @ViewBuilder trailingView: () -> Trailing,
        hasUnderLine: Bool = false
    ) {
        self.leadingView = leadingView()
        self.title = title
        self.trailingView = trailingView()
        self.hasUnderLine = hasUnderLine
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
        .overlay(alignment: .bottom) {
            if hasUnderLine {
                Color.gray700
                    .frame(height: 1)
            }
        }
    }
}

extension HeaderView where Leading == EmptyView {
    init(
        title: String? = nil,
        @ViewBuilder trailingView: () -> Trailing,
        hasUnderLine: Bool = false
    ) {
        self.leadingView = nil
        self.title = title
        self.trailingView = trailingView()
        self.hasUnderLine = hasUnderLine
    }
}

extension HeaderView where Trailing == EmptyView {
    init(
        @ViewBuilder leadingView: () -> Leading,
        title: String? = nil,
        hasUnderLine: Bool = false
    ) {
        self.leadingView = leadingView()
        self.title = title
        self.trailingView = nil
        self.hasUnderLine = hasUnderLine
    }
}

extension HeaderView where Leading == EmptyView, Trailing == EmptyView {
    init(title: String? = nil, hasUnderLine: Bool = true) {
        self.leadingView = nil
        self.title = title
        self.trailingView = nil
        self.hasUnderLine = hasUnderLine
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
