//
//  ViewExtension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation
import SwiftUI

extension View {
    func hideTabBar() -> some View {
        self.onAppear {
            // 탭바 숨기기
            UITabBar.appearance().isHidden = true
            
            // 투명하게 설정
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = .clear
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}
