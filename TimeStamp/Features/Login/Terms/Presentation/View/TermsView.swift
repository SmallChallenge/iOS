//
//  TermsView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import SwiftUI

/// 약관동의 받기 (이용약관, 개인정보처리 방침)
struct TermsView: View {
    
    @StateObject private var viewModel: TermsViewModel
    private let diContainer: LoginDIContainerProtocol
    private let onDismiss: (_ isActive: Bool) -> Void
    init(viewModel: TermsViewModel, diContainer: LoginDIContainerProtocol, onDismiss: @escaping (_ isActive: Bool) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.diContainer = diContainer
        self.onDismiss = onDismiss
    }
    
    @State private var isCheckedAll: Bool = false
    // 이용약관 체크
    @State private var isCheckedOfService: Bool = false
    // 개인정보처리방침 체크
    @State private var isCheckedOfPrivacy: Bool = false
    
    /// 이용약관 띄우기(웹뷰)
    @State private var showTermsOfService: Bool = false
    
    /// 개인정보처리방침  띄우기(웹뷰)
    @State private var showPrivacyPolicy: Bool = false

    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            
            HStack {
                Button {
                    isCheckedAll.toggle()
                    isCheckedOfService = isCheckedAll
                    isCheckedOfPrivacy = isCheckedAll
                    checkTerms()
                } label: {
                    CheckBox(isChecked: isCheckedAll) {
                        Text("전체 동의하고 시작")
                            .font(.H3)
                            .foregroundStyle(Color.gray900)
                    }
                }
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 36)
            
            
            
            Color.gray300
                .frame( height: 1)
            
            VStack(spacing: .zero){
                
                HStack {
                    Button {
                        isCheckedOfService.toggle()
                        isCheckedAll = isCheckedOfService && isCheckedOfPrivacy
                        checkTerms()
                    } label: {
                        CheckBox(isChecked: isCheckedOfService) {
                            Text("이용약관 (필수)")
                                .font(.Body1)
                                .foregroundStyle(Color.gray900)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        showTermsOfService = true
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(Color.gray900)
                            .padding([.vertical, .trailing], 5.33)
                            .padding(.leading, 8.33)
                    }
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 28)
                
                
                // 개인정보 처리방침
                HStack {
                    Button {
                        isCheckedOfPrivacy.toggle()
                        isCheckedAll = isCheckedOfService && isCheckedOfPrivacy
                        checkTerms()
                    } label: {
                        CheckBox(isChecked: isCheckedOfPrivacy) {
                            Text("개인정보 수집 및 이용 (필수)")
                                .font(.Body1)
                                .foregroundStyle(Color.gray900)
                        }
                    }

                    
                    Spacer()
                    
                    Button {
                        showPrivacyPolicy = true
                    } label: {
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.gray900)
                            .padding([.vertical, .trailing], 5.33)
                            .padding(.leading, 8.33)
                    }
                }
                .padding(.vertical, 11)
                .padding(.horizontal, 28)
            }
            .padding(.vertical, 10)

            Spacer()
        }
        .loading(viewModel.isLoading)
        .sheet(isPresented: $showTermsOfService) {
            diContainer.makeWebView(url: AppConstants.URLs.termsOfService) {
                showTermsOfService = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            diContainer.makeWebView(url: AppConstants.URLs.privacyPolicy) {
                showPrivacyPolicy = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        .onChange(of: viewModel.isActive) { isActive in
            if isActive {
                onDismiss(isActive)
            }
        }
        .onChange(of: scenePhase) { scenePhase in
            // 앱이 백그라운드로 가면 가입 취소 (LoginView로 전달)
            if scenePhase == .background {
                onDismiss(false)
            }
        }
        .toast(message: $viewModel.toastMessage)
    }
    
    private func checkTerms(){
        viewModel.saveTerms(
            isCheckedOfService: isCheckedOfService,
            isCheckedOfPrivacy: isCheckedOfPrivacy,
            isCheckedOfMarketing: false
        )
    }
}

#Preview {
    BottomSheetTestView2()
}
struct BottomSheetTestView2: View {
    @State private var showBottomSheet = true

    var body: some View {
        VStack {
            Text("Hello, World!")

            Button("바텀시트 열기") {
                showBottomSheet = true
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            MockLoginDIContainer().makeTermsView(loginEntity: nil, onDismiss: { _ in })
                .presentationDetents([.fraction(0.3)])
                .presentationDragIndicator(.visible)
        }
    }
}
