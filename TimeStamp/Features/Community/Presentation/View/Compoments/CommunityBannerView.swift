//
//  BannerView.swift
//  Stampic
//
//  Created by 임주희 on 1/10/26.
//

import SwiftUI

struct CommunityBannerView: View {
    let viewData: BannerViewData
    let loginAction: ()->Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                // 아이콘
                Image("logo_character")
                    .resizable()
                    .frame(width: 28, height: 35)
                    .padding(.top, 3)
                    .padding(.bottom, 2)
                    .padding(.horizontal, 6)
                
                // 메시지
                Text(viewData.message)
                    .font(.SubTitle2)
                    .foregroundStyle(Color.gray900)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            
            if viewData.type == .guest {
                Button(action: {
                    loginAction()
                }) {
                    Text("3초 만에 로그인하기")
                        .font(.SubTitle2)
                        .foregroundColor(.gray50)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .background(Color.gray900)
                .cornerRadius(8)
            }
        }
        .padding(.top, viewData.type == .guest ? 16 : 12)
        .padding(.horizontal, 20)
        .padding(.bottom, 12)
        .background(viewData.color)
        .cornerRadius(12)
        
    }
}
#Preview{
    VStack {
//        CommunityBannerView(viewData: BannerViewData.create(sequence: 0, isLoggedIn: true))
//        CommunityBannerView(viewData: BannerViewData.create(sequence: 1, isLoggedIn: true))
        CommunityBannerView(viewData: BannerViewData.create(sequence: 2, isLoggedIn: true), loginAction: {})
        CommunityBannerView(viewData: BannerViewData.create(sequence: 3, isLoggedIn: true), loginAction: {})
        
        CommunityBannerView(viewData: BannerViewData.create(sequence: 0, isLoggedIn: false), loginAction: {})
        CommunityBannerView(viewData: BannerViewData.create(sequence: 1, isLoggedIn: false), loginAction: {})
//        CommunityBannerView(viewData: BannerViewData.create(sequence: 2, isLoggedIn: false))
//        CommunityBannerView(viewData: BannerViewData.create(sequence: 3, isLoggedIn: false))
        
        
    }
    
}
