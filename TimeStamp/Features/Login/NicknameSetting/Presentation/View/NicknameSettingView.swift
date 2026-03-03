//
//  NicknameSettingView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import SwiftUI

struct NicknameSettingView: View {
    
    init(
        viewModel: NicknameSettingViewModel,
        onGoBack: @escaping () -> Void,
        onDismiss: (() -> Void)?,
        onSuccess: (() -> Void)? = nil
    ) {
        print(">>>>> init NicknameSettingView")
        self.onGoBack = onGoBack
        self.onDismiss = onDismiss
        self.onSuccess = onSuccess
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.oldNickname = AuthManager.shared.currentUser?.nickname ?? ""
    }
    

    let onGoBack: () -> Void
    let onDismiss: (() -> Void)?
    let onSuccess: (() -> Void)?

    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: NicknameSettingViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var isReadyKeyboard = false
    @State private var newNickname: String = ""
    private let oldNickname: String
    
    var body: some View {
            VStack(spacing: .zero) {
                // 헤더
                HeaderView(leadingView: {
                    // 뒤로가기 버튼
                    BackButton {
                        onGoBack()
                    }
                }, trailingView: {
                    if onDismiss != nil {
                        CloseButton {
                            onDismiss?()
                        }
                    } else {
                        EmptyView()
                    }
                })
                
                    VStack(spacing: .zero) {
                        
                        Spacer()
                        
                        VStack (spacing: 4) {
                            Text("닉네임 입력")
                                .font(.custom("Pretendard-SemiBold", size: 32))
                                .foregroundStyle(Color.gray50)
                            
                            Text("\(AppConstants.AppInfo.appNameEn)에서 사용할 닉네임을 입력해주세요.")
                                .font(.Body1)
                                .foregroundStyle(Color.gray400)
                        }
                        
                        Spacer()
                            .frame(maxHeight: 80)
                        
                        VStack(spacing: 12) {
                            // 입력필드
                            TextField(authManager.currentUser?.nickname ?? "닉네임", text: $newNickname)
                                .font(.H2)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.gray50)
                                .focused($isTextFieldFocused)
                                .onSubmit {
                                    if (newNickname.isNotEmpty && viewModel.validateMessage == nil && oldNickname != newNickname){
                                        viewModel.saveNickname(newNickname)
                                    }
                                }
                            
                            // 밑줄
                            ((newNickname.isEmpty || viewModel.validateMessage.isEmptyOrNil) ? Color.neon300 : Color.error)
                                .frame(height:1)
                            
                            Text(viewModel.validateMessage ?? "")
                                .font(.caption)
                                .foregroundStyle(newNickname.isEmpty ? Color.clear : Color.error)
                        }
                        .padding(.horizontal, 48)
                        
                            Spacer()
                    }

                MainButton(title: "확인", isDisabled: (newNickname.isEmpty || viewModel.validateMessage != nil || oldNickname == newNickname)) {
                    viewModel.saveNickname(newNickname)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            } // ~VStack
            .loading(viewModel.isLoading)
            .onAppear(perform: {
                self.newNickname = authManager.currentUser?.nickname ?? ""
            })
            .task {
                try? await Task.sleep(nanoseconds: 100_000_000)
                isTextFieldFocused = true
            }
            .onChange(of: newNickname){ newValue in
                viewModel.resetValidateMessage()
                let _ = viewModel.checkValidateNickname(newValue)
            }
            // 저장 성공 시 로그인뷰 닫기 및 성공 핸들러 호출
            .onChange(of: viewModel.isSaved) { isSaved in
                if isSaved {
                    // 다음 런루프에서 실행하여 feedback loop 방지
                    Task { @MainActor in
                        onSuccess?()
                        onDismiss?()
                    }
                }
            }
            .mainBackgourndColor()
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    MockLoginDIContainer().makeNicknameSettingView(loginEntity: nil, onGoBack: { }, onDismiss: {}, onSuccess: {})
}
