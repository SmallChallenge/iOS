//
//  PhotoSaveView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//


import SwiftUI

/// 사진 저장 화면
// 카테고리, 공개 여부 선택
// 사진 저장
struct PhotoSaveView: View {
    @Environment(\.dismiss) var goBack
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject var viewModel: PhotoSaveViewModel
    let capturedImage: UIImage
    let onGoBack: (() -> Void)? //일단 안씀. 안되서, 위의 dismiss를 사용
    let onComplete: () -> Void
    
    
    @State private var selectedCategory: CategoryViewData? = nil
    @State private var selectedVisibility: VisibilityViewData? = nil
    @State private var didAttemptConfirm: Bool = false
    @State private var showLoginPopup: Bool = false
    @State private var showLoginView: Bool = false
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 0){
              
                // 이미지뷰
                Image(uiImage: capturedImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .roundedBorder(color: .gray700, radius: 8)
                    .padding(.top, 28)
                    .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 32)

                // 카테고리 선택
                categoryPicker
                    .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 40)

                // 공개여부 선택
                visibilityPicker
                    .padding(.horizontal, 20)
                
                Spacer()
                    .frame(height: 8)
                
                Text("👆전체 공개 설정하고 커뮤니티 활동을 시작해보세요!")
                    .font(.Body2)
                    .foregroundStyle(Color.gray500)
                    .padding(.horizontal, 20)
            } // ~VStack
        } // ~ ScrollView
        .safeAreaInset(edge: .top) {
            // 헤더
            HeaderView(
                
                leadingView: {
                    BackButton {
                        goBack()
                    }
                    
                }, trailingView: {
                    MainButton(title: "완료", size: .small) {
                        savePhoto()
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.trailing, 20)
                })
            .background(Color.gray900)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .mainBackgourndColor()
        .loading(viewModel.isLoading)
        // 로그인 팝업 띄우기
        .popup(isPresented: $showLoginPopup, content: {
            Modal(title: "로그인하면 내 기록을\n커뮤니티에 공유할 수 있어요.")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        showLoginPopup = false
                    }
                    MainButton(title: "로그인", colorType: .primary) {
                        // 로그인 화면 띄우기
                        showLoginPopup = false
                        showLoginView = true
                    }
                }
        })
        // 로그인 화면 띄우기
        .fullScreenCover(isPresented: $showLoginView, content: {
            AppDIContainer.shared.makeLoginView {
                showLoginView = false
            }
        })
        
        // 저장 성공 시 CameraView까지 닫기 (MainTabView로 돌아가기)
        .onChange(of: viewModel.isSaved) { isSaved in
            if isSaved {
                onComplete()
            }
        }
        .toast(message: $viewModel.toastMessage)
        .popup(isPresented: Binding(
            get: { viewModel.alertMessage != nil },
            set: { if !$0 { viewModel.alertMessage = nil } }
        ), content: {
            Modal(title: viewModel.alertMessage ?? "")
                .buttons {
                    MainButton(title: "확인", colorType: .primary) {
                        viewModel.alertMessage = nil
                    }
                }
        })
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
        }
    }
    
    // MARK: - Actions

    private func savePhoto() {
        didAttemptConfirm = true
        
        // 카테고리, 공개 여부가 선택되었는지 확인
        guard let category = selectedCategory,
        let visibility = selectedVisibility
        else {
            viewModel.show(.requiredSelection)
            return
        }
        
        // ViewModel을 통해 저장
        viewModel.savePhoto(
            image: capturedImage,
            category: category,
            visibility: visibility
        )
    }
    
}



#Preview {
    MockCameraDIContainer().makePhotoSaveView(
        capturedImage: UIImage(named: "sampleImage")!,
        selectedCategoryType: "",
        selectedTamplateId: ""
        , onGoBack: {}, onComplete: {})
}
