//
//  UserInfoPageView.swift
//  Stampic
//
//  Created by 임주희 on 1/1/26.
//

import SwiftUI

struct UserInfoPageView: View {
    
    private let appDiContainer = AppDIContainer.shared
    @State private var presentNicknameSetting: Bool = false
    
    private let onGoBack: (_ needRefresh: Bool) -> Void
    init(onGoBack: @escaping (_ needRefresh: Bool) -> Void) {
        self.onGoBack = onGoBack
    }
    var body: some View {
        ZStack {
            // Body
            VStack {
                Button("닉네임설정") {
                    presentNicknameSetting = true
                }
            }

        }// ~ZStack
        .navigationDestination(isPresented: $presentNicknameSetting) {
            appDiContainer.makeNicknameSettingView(onGoBack: { needRefresh in
                print(">>>>> needRefresh \(needRefresh)")
            // TODO: 내 정보 갱신
                presentNicknameSetting = false
                
            }, onDismiss: nil)
        }
        .mainBackgourndColor()
        
    }
}

#Preview {
    MockMyPageDIContainer().makeUserInfoPageView(onGoBack: { _ in})
}
