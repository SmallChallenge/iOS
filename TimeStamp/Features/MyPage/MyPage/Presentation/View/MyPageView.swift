//
//  MyPageView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import SwiftUI

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
            
            NavigationLink(isActive: $presentUserInfo) {
                diContainer.makeUseInfoPageView { needRefresh in
                    print(">>>>> needRefresh \(needRefresh)")
                    presentUserInfo = false
                }
            } label: {
                EmptyView()
            }

            
            VStack(spacing: 10) {
                if authManager.isLoggedIn {
                    
                    Button {
                        presentUserInfo = true
                    } label: {
                        Text("내 정보")
                    }

                    Button("로그아웃"){
                        viewModel.logout()
                    }
                } else {
                    Button("로그인") {
                        showLoginView = true
                    }
                }
                
                
             
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            appDiContainer.makeLoginView {
                showLoginView = false
            }
        }
        
    }
}

#Preview {
    MockMyPageDIContainer().makeMyPageView()
}
