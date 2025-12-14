//
//  MainView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView (selection: $selectedTab){
                MyLogView()
                    .tag(0)
                CameraView()
                    .tag(1)
                CommunityView()
                    .tag(2)
            } //~TabView
            .hideTabBar()
            
            CustomTabBar(selectedTab: $selectedTab)
            
        } // ~ZStack
        .ignoresSafeArea()
    }
}

#Preview {
    MainTabView()
}
