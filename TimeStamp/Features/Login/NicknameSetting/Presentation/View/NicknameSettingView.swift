//
//  NicknameSettingView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import SwiftUI

struct NicknameSettingView: View {
    
    init(viewModel: NicknameSettingViewModel, onGoBack: @escaping (_ needRefresh: Bool) -> Void, onDismiss: (() -> Void)?) {
        self.onGoBack = onGoBack
        self.onDismiss = onDismiss
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    let onGoBack: (_ needRefresh: Bool) -> Void
    let onDismiss: (() -> Void)?
    
    @StateObject private var viewModel: NicknameSettingViewModel
    @State private var text: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                ScrollView {
                    VStack(spacing: .zero) {
                        
                        Spacer()
                            .frame(height: isTextFieldFocused ? 80 : geometry.size.height * 0.2)
                        
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
                            TextField("닉네임", text: $text)
                                .font(.H2)
                                .multilineTextAlignment(.center)
                                .focused($isTextFieldFocused)
                                .foregroundStyle(Color.gray50)
                            
                            // 밑줄
                            ((text.isEmpty || viewModel.validateMessage.isEmptyOrNil) ? Color.neon300 : Color.error)
                                .frame(height:1)
                            
                            Text(viewModel.validateMessage ?? "")
                                .font(.caption)
                                .foregroundStyle(text.isEmpty ? Color.clear : Color.error)
                        }
                        .padding(.horizontal, 48)
                        
                        if !isTextFieldFocused {
                            Spacer()
                                .frame(height: geometry.size.height * 0.3)
                        }
                        
                    }
                    .frame(minHeight: geometry.size.height - 80)
                }
                .scrollDismissesKeyboard(.interactively)

                MainButton(title: "확인", isDisabled: text.isEmpty || viewModel.validateMessage != nil) {
                    viewModel.saveNickname(text)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            } // ~VStack
            .loading(viewModel.isLoading)
            .onChange(of: text){ newValue in
                viewModel.checkValidateNickname(newValue)
            }
            // 저장 성공 시 로그인뷰 닫기
            .onChange(of: viewModel.isSaved) { isSaved in
                if isSaved {
                    onDismiss?()
                }
            }
            .mainBackgourndColor()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 뒤로가기 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        onGoBack(viewModel.isSaved)
                    }
                }
                
                // 닫기 버튼
                if onDismiss != nil {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        CloseButton {
                            onDismiss?()
                        }
                        .padding(.trailing, -12)
                    }
                }
            }
        }
    }
}

#Preview {
    MockLoginDIContainer().makeNicknameSettingView(onGoBack: { _ in}, onDismiss: {})
}
