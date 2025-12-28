//
//  TermsView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import SwiftUI

struct TermsView: View {
    
    @StateObject private var viewModel: TermsViewModel
    private let diContainer: LoginDIContainerProtocol
    private let onDismiss: (_ isActive: Bool) -> Void
    private let accessToken: String?
    init(viewModel: TermsViewModel, diContainer: LoginDIContainerProtocol, accessToken token: String?,  onDismiss: @escaping (_ isActive: Bool) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.diContainer = diContainer
        self.accessToken = token
        self.onDismiss = onDismiss
    }
    
    // 이용약관 체크
    @State private var isCheckedOfService: Bool = false
    // 개인정보처리방침 체크
    @State private var isCheckedOfPrivacy: Bool = false
    
    /// 이용약관 띄우기(웹뷰)
    @State private var showTermsOfService: Bool = false
    
    /// 개인정보처리방침  띄우기(웹뷰)
    @State private var showPrivacyPolicy: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                CheckBox(isChecked: $isCheckedOfService, title: "이용약관 동의")
                
                Spacer()
                
                Button {
                    showTermsOfService = true
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray50)
                }
            }
            .padding(.horizontal, 20)
            
            // 개인정보 처리방침
            HStack {
                CheckBox(isChecked: $isCheckedOfPrivacy, title: "개인정보 처리방침 동의")
                
                Spacer()
                
                Button {
                    showPrivacyPolicy = true
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray50)
                }
            }
            .padding(.horizontal, 20)
            
            MainButton(title: "확인", isDisabled: !(isCheckedOfService && isCheckedOfPrivacy)) {
                // 계정 활성화
                viewModel.saveTerms(
                    accessToken: accessToken,
                    isCheckedOfService: isCheckedOfService,
                    isCheckedOfPrivacy: isCheckedOfPrivacy,
                    isCheckedOfMarketing: false)
            }
        }
        .mainBackgourndColor()
        .loading(viewModel.isLoading)
        .sheet(isPresented: $showTermsOfService) {
            diContainer.makeWebView(url: AppConstants.URLs.termsOfService) {
                showTermsOfService = false
            }
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            diContainer.makeWebView(url: AppConstants.URLs.privacyPolicy) {
                showPrivacyPolicy = false
            }
        }
        .onChange(of: viewModel.isActive) { isActive in
            if isActive {
                onDismiss(isActive)
            }
        }
        .toast(message: $viewModel.toastMessage)
    }
}

#Preview {
    MockLoginDIContainer().makeTermsView(accessToken: "", onDismiss: { _ in })
}
