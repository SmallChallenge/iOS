//
//  MainTabBar.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI


struct MainTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showCamera: Bool

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                HStack(spacing: 0) {

                    // MARK: 내 기록
                    TabButton(
                        type: .myLog,
                        isSelected: selectedTab == 0) {
                        selectedTab = 0
                    }

                    // MARK: 카메라
                    Button {
                        showCamera = true
                    } label: {
                        AddButtonView()
                    }
                    .offset(y: -20) // 위로 튀어나오게


                    // MARK: 커뮤니티
                    TabButton(
                        type: .community,
                        isSelected: selectedTab == 2) {
                            selectedTab = 2
                        }


                }
                .frame(height: 58)

                // Safe Area 영역 채우기
                Color.gray900
                    .frame(height: geometry.safeAreaInsets.bottom)
            }
            .background(
                Color.gray900
            )
        }
        .frame(height: 58)
        .ignoresSafeArea(edges: .bottom)
    }
}


#Preview {
    MainTabBar(selectedTab: .constant(1), showCamera: .constant(false))
}
