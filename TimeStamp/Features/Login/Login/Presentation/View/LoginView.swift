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
    private let diContainer: LoginDIContainerProtocol
    private let onDismiss: () -> Void

    init(viewModel: LoginViewModel, diContainer: LoginDIContainerProtocol, onDismiss: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.diContainer = diContainer
        self.onDismiss = onDismiss
    }

    // 닉네임 설정 화면으로 넘어가기
    @State private var navigateToNicknameSetting = false
    /// 약관동의  sheet띄우기 (동의 받기)
    @State private var showTermsSheet: Bool = false
    
    /// 이용약관 띄우기(웹뷰)
    @State private var showTermsWebView: Bool = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                    .frame(maxHeight: 115)
                
                Image("logo_white")
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
                    
                    // 이용약관 띄우기
                    Button {
//                         showTermsWebView = true
                        showTermsSheet = true
                        
                    } label: {
                        Text(AttributedString("이용약관", attributes: AttributeContainer([.underlineStyle: NSUnderlineStyle.single.rawValue])))
                            .font(.Caption)
                    }
                    
                    Text("에 동의하는 것으로 간주됩니다.")
                        .font(.Caption)
                }
                .foregroundStyle(Color.gray600)
                
                Spacer()
                
                
                // 닉네임 설정 화면으로 넘기기
                NavigationLink(destination:
                                diContainer.makeNicknameSettingView(
                                    onGoBack: { navigateToNicknameSetting = false },
                                    onDismiss: onDismiss
                                )
                               , isActive: $navigateToNicknameSetting) {
                    EmptyView()
                }
            }// ~Vstack
            .toast(message: $viewModel.toastMessage)
            .popup(message: $viewModel.alertMessage)
            .loading(viewModel.isLoading)
            .mainBackgourndColor()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // 닫기 버튼
                    CloseButton {
                        onDismiss()
                    }
                    .padding(.trailing, -12)
                }
            }
            .onChange(of: viewModel.isLoggedIn) { isLoggedIn in
                if isLoggedIn {
                    // 로그인 성공 시, 로그인 화면 닫기
                    onDismiss()
                }
            }
            .onChange(of: viewModel.needNickname) { needNickname in
                if needNickname {
                    navigateToNicknameSetting = true
                }
            }
            .onChange(of: viewModel.needTerms) { needTerms in
                if needTerms {
                    showTermsSheet = true
                }
            }
            .sheet(isPresented: $showTermsWebView) {
                diContainer.makeWebView(url: AppConstants.URLs.termsOfService) {
                        showTermsWebView = false
                    }
            }
            .bottomSheet(isPresented: $showTermsSheet, onDismiss: {
                viewModel.needTerms = false
            }) {
                diContainer.makeTermsView(
                    accessToken: viewModel.pendingLoginEntity?.accessToken, onDismiss: { isActive in
                    if isActive {
                        showTermsSheet = false
                        // 약관 완료 후 닉네임 필요한지 체크
                        viewModel.onTermsCompleted()
                    }
                    viewModel.needTerms = false
                })
                .frame(height: UIScreen.main.bounds.height * 0.3)
            }
        } // ~NavigationView
    }
}

#Preview {
    AppDIContainer.shared.makeLoginView(onDismiss: {})
}

