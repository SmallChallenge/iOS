//
//  NicknameSettingView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import SwiftUI

struct NicknameSettingView: View {
    let onGoBack: () -> Void
    let onDismiss: () -> Void
    
    
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
                            
                            Text("STAMPTY에서 사용할 닉네임을 입력해주세요.")
                                .font(.Body1)
                                .foregroundStyle(Color.gray400)
                        }
                        
                        Spacer()
                            .frame(maxHeight: 80)
                        
                        
                        VStack(spacing: 12) {
                            TextField("입력", text: $text)
                                .font(.H2)
                                .multilineTextAlignment(.center)
                                .focused($isTextFieldFocused)
                                .foregroundStyle(Color.gray50)
                            
                            Color.neon300
                                .frame(height:1)
                        }
                        .padding(.horizontal, 48)
                        
                        if !isTextFieldFocused {
                            Spacer()
                                .frame(height: geometry.size.height * 0.3)
                        }
                        
                    }
                    .frame(minHeight: geometry.size.height - 80)
                }
                
                MainButton(title: "확인") {
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            } // ~VStack
            .mainBackgourndColor()
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                // 뒤로가기 버튼
                ToolbarItem(placement: .navigationBarLeading) {
                    BackButton {
                        onGoBack()
                    }
                }
                
                // 닫기 버튼
                ToolbarItem(placement: .navigationBarTrailing) {
                    CloseButton {
                        onDismiss()
                    }
                    .padding(.trailing, -12)
                }
            }
        }
    }
}

#Preview {
    NicknameSettingView(onGoBack: {}, onDismiss: {})
}
