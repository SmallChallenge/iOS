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
    private let onDismiss: () -> Void
    init(viewModel: LoginViewModel, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(maxHeight: 115)
            
            Image("LoginAppIcon")
                .resizable()
                .frame(width: 90, height: 90)
            
            Spacer()
                .frame(maxHeight: 45)
                
            Text("자랑하고 싶은 나의 하루,\n스탬피로 기록하세요!")
                .font(.H2)
                .foregroundStyle(Color.gray50)
            
            Spacer()
                .frame(maxHeight: 60)
            
            VStack(spacing: 16) {
                // 카카오 로그인
                SocialLoginButton(type: .kakao) {
                    viewModel.clickKakaoLoginButton()
                }
                
                // 구글 로그인
                SocialLoginButton(type: .google) {
                    viewModel.clickGoogleLoginButton()
                }
                
                // 애플 로그인
                SocialLoginButton(type: .apple) {
                    viewModel.clickAppleLoginButton()
                }
            }
            .padding(.horizontal, 20)
            
            Spacer()
                .frame(maxHeight: 40)
            
            HStack(spacing: .zero) {
                Text("로그인하시면 ")
                    .font(.Caption)
                Button {
                    
                } label: {
                    Text(AttributedString("이용약관", attributes: AttributeContainer([.underlineStyle: NSUnderlineStyle.single.rawValue])))
                        .font(.Caption)
                }
                
                Text("에 동의하는 것으로 간주됩니다.")
                    .font(.Caption)
            }
            .foregroundStyle(Color.gray600)
            
            Spacer()
        }// ~Vstack
        .mainBackgourndColor()
        .onChange(of: viewModel.isLoggedIn) { isLoggedIn in
            if isLoggedIn {
                // 로그인 성공 시, 로그인 화면 닫기
                onDismiss()
            }
        }
    }
}

#Preview {
    AppDIContainer.shared.makeLoginView(onDismiss: {})
}

