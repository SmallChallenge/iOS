//
//  LoginView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/13/25.
//

import Foundation
import SwiftUI


struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            
            Button {
                viewModel.clickAppleLoginButton()
            } label: {
                Text("애플 로그인")
            }

        }
        .padding()
    }
}


