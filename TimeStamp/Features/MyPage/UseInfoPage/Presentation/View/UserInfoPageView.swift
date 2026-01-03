//
//  UserInfoPageView.swift
//  Stampic
//
//  Created by 임주희 on 1/1/26.
//

import SwiftUI

struct UserInfoPageView: View {

    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: UserInfoPageViewModel

    // 닉네임 설정 화면으로
    @State private var presentNicknameSetting: Bool = false

    @State private var showSignOutPopup: Bool = false

    private let appDiContainer = AppDIContainer.shared
    private let onGoBack: () -> Void

    init(viewModel: UserInfoPageViewModel, onGoBack: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onGoBack = onGoBack
    }
    var body: some View {
        ScrollView {
            // Body
            VStack (spacing: .zero){
                thinLine
                
                profile
                
                MyPageMenu("닉네임설정", type: .chevronText(text: "\(authManager.currentUser?.nickname ?? "")")) {
                    presentNicknameSetting = true
                }
                
                loginPromptBannerView
                    .padding(.top, 8)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
                
                thinLine
                
                MyPageMenu("회원탈퇴") {
                    showSignOutPopup = true
                }
            }

        }// ~ZStack
        .mainBackgourndColor()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("내 정보")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // 뒤로가기 버튼
                BackButton {
                    onGoBack()
                }
            }
        }
        // 토스트 메시지
        .toast(message: $viewModel.toastMessage)
        .loading(viewModel.isLoading)
        // 닉네임 설정 화면으로
        .navigationDestination(isPresented: $presentNicknameSetting) {
            appDiContainer.makeNicknameSettingView(
                loginEntity: nil,
                onGoBack: { presentNicknameSetting = false },
                onDismiss: nil,
                onSuccess: { presentNicknameSetting = false }
            )
        }
        // 회원탈퇴 팝업띄우기
        .popup(isPresented: $showSignOutPopup) {
            Modal(title: "탈퇴하시겠습니까?",
                  content: "탈퇴 후 7일 이내 재로그인 시 데이터가 복구됩니다.\n7일 이후에는 모든 정보가 영구 삭제됩니다.")
                .buttons {
                    MainButton(title: "취소" , size: .middle, colorType: .secondary){
                        showSignOutPopup = false
                    }
                    MainButton(title: "탈퇴" , size: .middle, colorType: .primary){
                        viewModel.signout()
                        showSignOutPopup = false
                    }
                }
        }
        // 회원탈퇴 성공 시 화면 닫기
        .onChange(of: viewModel.withdrawalSuccess) { success in
            if success {
                Task { @MainActor in
                    onGoBack()
                }
            }
        }
        
    }
    
    private var thinLine: some View {
        Color.gray700
            .frame(height: 1)
    }
    private var thickLine: some View {
        Color.gray800
            .frame(height: 16)
    }
    private var profile: some View {
        Image("profile")
            .resizable()
            .frame(width: 80, height: 80)
            .padding(.top, 40)
            .padding(.bottom, 32)
    }
    
    private var loginPromptBannerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("현재 사용 중인 기능")
                .font(.SubTitle2)
                .foregroundStyle(Color.gray50)
            
            VStack (alignment: .leading, spacing: 12){
                //자동 백업 및 무제한 기록
                HStack {
                    Text("✓")
                        .font(.Body2)
                        .foregroundStyle(Color.neon300)
                    
                    Text("자동 백업 및 무제한 기록")
                        .font(.Body2)
                    
                    Spacer()
                }
                
                HStack {
                    Text("✓")
                        .font(.Body2)
                        .foregroundStyle(Color.neon300)
                    
                    Text("자유로운 공개 여부 설정")
                        .font(.Body2)
                    
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("로그인 전 기록은 백업·공개가 불가해요.")
                        .font(.Caption)
                    
                    Spacer()
                }
                .foregroundStyle(Color.gray500)
                
            }

            .foregroundStyle(Color.gray50)
            
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(Color.gray800)
        .rounded(radius: 16)
    }
}

#Preview {
    MockMyPageDIContainer().makeUserInfoPageView(onGoBack: { })
}

