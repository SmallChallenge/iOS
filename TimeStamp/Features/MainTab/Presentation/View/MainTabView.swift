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
    @State private var showCamera: Bool = false

    private let container = AppDIContainer.shared

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView (selection: $selectedTab){
                container.makeMyLogView()
                    .tag(0)

                EmptyView()
                    .tag(1)

                container.makeCommunityView()
                    .tag(2)
            } //~TabView
            .hideTabBar()

            MainTabBar(selectedTab: $selectedTab, showCamera: $showCamera)

        } // ~ZStack
        .fullScreenCover(isPresented: $showCamera) {
            container.makeCameraView {
                showCamera = false
            }
        }
    }
}

#Preview {
    MainTabView()
}
