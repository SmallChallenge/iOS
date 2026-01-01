//
//  UseInfoPageView.swift
//  Stampic
//
//  Created by 임주희 on 1/1/26.
//

import SwiftUI

struct UseInfoPageView: View {
    
    private let appDiContainer = AppDIContainer.shared
    @State private var presentNicknameSetting: Bool = false
    
    private let onGoBack: (_ needRefresh: Bool) -> Void
    init(onGoBack: @escaping (_ needRefresh: Bool) -> Void) {
        self.onGoBack = onGoBack
    }
    var body: some View {
        ZStack {
            NavigationLink(isActive: $presentNicknameSetting) {
                appDiContainer.makeNicknameSettingView(onGoBack: {}, onDismiss: {
                    needRefresh in
                        print(">>>>> needRefresh \(needRefresh)")
                })
            } label: {
                EmptyView()
            }

            // Body
            VStack {
                Button("닉네임설정") {
                    presentNicknameSetting = true
                }
            }

        }// ~ZStack
        .mainBackgourndColor()
        
    }
}

#Preview {
    MockMyPageDIContainer().makeUseInfoPageView(onGoBack: { _ in})
}
