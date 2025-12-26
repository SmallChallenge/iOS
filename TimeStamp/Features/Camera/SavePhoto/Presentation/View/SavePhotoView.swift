//
//  SavePhotoView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//


import SwiftUI

/// 사진 저장 화면
// 카테고리, 공개 여부 선택
// 사진 저장
struct SavePhotoView: View {
    
    @StateObject var viewModel: SavePhotoViewModel
    let capturedImage: UIImage
    let onGoBack: (() -> Void)?
    let onDismiss: () -> Void
    
    
    @ObservedObject private var authManager = AuthManager.shared
    @State private var selectedCategory: CategoryViewData? = nil
    @State private var didAttemptConfirm: Bool = false
    @State private var showLoginPopup: Bool = false
    @State private var showLoginView: Bool = false
    
    

    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 0){

                // 이미지뷰
                Image(uiImage: capturedImage)
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .roundedBorder(color: .gray700, radius: 8)
                    .padding(.top, 28)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)

                // 카테고리 선택
                categoryPicker
                    .padding(.horizontal, 20)

                // 공개여부 선택
                visibilityPicker
                    .padding(.top, 40)
                    .padding(.horizontal, 20)
            }
        }
        .mainBackgourndColor()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                DismissButton {
                    onGoBack?()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                MainButton(title: "완료", size: .small) {
                    savePhoto()
                }
                .disabled(viewModel.isLoading)
            }
        }
        .loading(viewModel.isLoading)
        .popup(isPresented: $showLoginPopup, content: {
            Modal(title: "로그인이 필요합니다.")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        showLoginPopup = false
                    }
                    MainButton(title: "확인", colorType: .primary) {
                        // 로그인 화면 띄우기
                        showLoginPopup = false
                        showLoginView = true
                    }
                }
        })
        .sheet(isPresented: $showLoginView, content: {
            AppDIContainer.shared.makeLoginView {
                showLoginView = false
            }
        })
        .onChange(of: viewModel.isSaved) { isSaved in
            if isSaved {
                // 저장 성공 시 CameraView까지 닫기 (MainTabView로 돌아가기)
                onDismiss()
            }
        }
        .toast(message: $viewModel.toastMessage)
        .alert("오류", isPresented: .constant(viewModel.alertMessage != nil)) {
            Button("확인") {
                viewModel.alertMessage = nil
            }
        } message: {
            if let errorMessage = viewModel.alertMessage {
                Text(errorMessage)
            }
        }
        
    }

    // MARK: - Actions

    private func savePhoto() {
        didAttemptConfirm = true
        
        // 카테고리, 공개 여부가 선택되었는지 확인
        guard let category = selectedCategory,
        let visibility = selectedVisibility
        else { return }
        
        // ViewModel을 통해 저장
        viewModel.savePhoto(
            image: capturedImage,
            category: category,
            visibility: visibility
        )
    }
    
    
    
   
    // 카테고리 선택
    var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("카테고리 선택")
                    .font(.SubTitle2)
                    .foregroundStyle(.gray50)
                
                if didAttemptConfirm && selectedCategory == nil {
                    Text("* 필수 선택")
                        .foregroundStyle(Color.error)
                        .font(.caption)
                }
            }
            
            HStack(alignment: .center, spacing: 8){
                ForEach(CategoryViewData.allCases, id: \.self) { category in
                    CategoryButton(
                        type: category,
                        state: {
                            if selectedCategory == nil {
                                return .normal
                            } else if selectedCategory == category {
                                return .selected
                            } else {
                                return .unselected
                            }
                        }()
                    ) {
                        selectedCategory = category
                    }
                }
                
                Spacer()
            }
        }
    }
    
    @State var selectedVisibility: VisibilityViewData? = nil
    /// 공개여부 선택
    var visibilityPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8){
                Text("공개 여부 선택")
                    .font(.SubTitle2)
                    .foregroundStyle(.gray50)
                
                if didAttemptConfirm && selectedVisibility == nil {
                    Text("* 필수 선택")
                        .foregroundStyle(Color.error)
                        .font(.caption)
                }
            }
            
            HStack(spacing: 8){
                // 전체 공개
                TagButton(
                    title: VisibilityViewData.publicVisible.title,
                    isActive: selectedVisibility == .publicVisible) {
                        guard authManager.isLoggedIn else {
                            showLoginPopup = true
                            return
                        }
                        selectedVisibility = .publicVisible
                    }
                
                // 비공개
                TagButton(
                    title: VisibilityViewData.privateVisible.title,
                    isActive: selectedVisibility == .privateVisible) {
                        selectedVisibility = .privateVisible
                    }
            }
            
            Text("👆전체 공개 설정하고 커뮤니티 활동을 시작해보세요!")
                .font(.Body2)
                .foregroundStyle(Color.gray500)
        }
    }
}



#Preview {
    MockCameraDIContainer().makeSavePhotoView(capturedImage: UIImage(), onDismiss: {}, onGoBack: {})
}
