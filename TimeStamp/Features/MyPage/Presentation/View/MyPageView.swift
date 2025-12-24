//
//  MyPageView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import SwiftUI

/// 마이페이지 화면
struct MyPageView: View {
    @StateObject private var viewModel: MyPageViewModel
    @State var showLoginSheet: Bool = false
    private let container = AppDIContainer.shared
    
    
    init(viewModel: MyPageViewModel){
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        VStack {
            Button("로그인") {
                showLoginSheet = true
            }
            Button("로그아웃"){
                viewModel.logout()
            }
        }
        .sheet(isPresented: $showLoginSheet) {
            container.makeLoginView()

        }
        
    }
}

#Preview {
    MyPageView(viewModel: MyPageViewModel())
}
