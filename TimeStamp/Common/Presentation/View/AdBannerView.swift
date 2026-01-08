//
//  AdBannerView.swift
//  TimeStamp
//
//  Created by 임주희 on 1/8/26.
//

import GoogleMobileAds
import SwiftUI
import UIKit


// SwiftUI 래퍼
struct BannerAd: View {
    var body: some View {
        AdBannerView()
            .background(Color.clear)
    }
}

struct AdBannerView: UIViewRepresentable {
    typealias UIViewType = BannerView
    init() { }
    
    func makeUIView(context: Context) -> BannerView {
           let bannerView = BannerView()
           bannerView.adUnitID = AppConstants.SDKKeys.ad_banner
           
           // Root ViewController 설정
           if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController {
               bannerView.rootViewController = rootViewController
           }
           
           bannerView.adSize = AdSizeBanner
           return bannerView
       }
    func updateUIView(_ uiView: BannerView, context: Context) {
            let request = Request()
            uiView.load(request)
        }
}
