//
//  MyPageView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import SwiftUI
import UIKit

/// 마이페이지 화면
struct MyPageView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: MyPageViewModel
    private let appDiContainer = AppDIContainer.shared
    private let diContainer: MyPageDIContainerProtocol
    
    
    @State var showLoginView: Bool = false
    @State var presentUserInfo: Bool = false
    
    init(viewModel: MyPageViewModel, diContainer: MyPageDIContainerProtocol){
        _viewModel = StateObject(wrappedValue: viewModel)
        self.diContainer = diContainer
    }
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                if authManager.isLoggedIn {
                    
                    Button {
                        presentUserInfo = true
                    } label: {
                        Text("내 정보")
                    }

                    Button("로그아웃"){
                        viewModel.logout()
                    }
                    
                    Button("토큰복사"){
                        copyTokenForTest()
                    }
                    
                } else {
                    Button("로그인") {
                        showLoginView = true
                    }
                }

            }
        }
        .navigationDestination(isPresented: $presentUserInfo) {
            diContainer.makeUseInfoPageView { needRefresh in
                print(">>>>> needRefresh \(needRefresh)")
                presentUserInfo = false
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            appDiContainer.makeLoginView {
                showLoginView = false
            }
        }
        
    }
    
    private func copyTokenForTest(){
        guard let token = authManager.getAccessToken() else {
            ToastManager.shared.show("토큰이 없습니다")
            return
        }

        // 클립보드에 복사
        UIPasteboard.general.string = token

        // 복사 완료 토스트
        ToastManager.shared.show("토큰이 복사되었습니다")
    }
}

#Preview {
    MockMyPageDIContainer().makeMyPageView()
}
