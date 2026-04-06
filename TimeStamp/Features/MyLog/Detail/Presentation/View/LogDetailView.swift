//
//  LogDetailView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/30/25.
//

import SwiftUI
import Kingfisher
import Photos

/// 기록 상세 보기 화면
struct LogDetailView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: LogDetailViewModel
    private let diContainer: MyLogDIContainerProtocol
    let onGoBack: (() -> Void)
    init(viewModel: LogDetailViewModel, diContainer: MyLogDIContainerProtocol, onGoBack: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onGoBack = onGoBack
        self.diContainer = diContainer
        
        // 삭제 성공 시 뒤로가기 (이미 DIContainer에서 설정되어 있음)
        // viewModel.onDeleteSuccess는 DIContainer에서 설정됨
    }
    
    @State private var showDeletePopup: Bool = false
    @State private var showShareSheet: Bool = false
    
    @State private var navigateToEditor: Bool = false
    @State private var hasAppeared: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // 이미지 뷰
                logImage
                    .padding(.bottom, 7 )
                
                VStack(alignment: .leading, spacing: 17) {
                    
                    // 카테고리 + 공개여부
                    HStack(alignment: .top, spacing: 12) {
                        
                        Spacer()
                            .frame(width: 110)
                        
                        // 공개 여부
                        if viewModel.isPublicVisibility() {
                            // 스위치...
                            SegmentedToggleView(selectedTab: $viewModel.visibility)
                                .frame(width: 140, height: 40)
                                .onChange(of: viewModel.visibility) { visibility in
                                    viewModel.updateLog()
                                }
                            
                        } else {
                            privateTag
                        }
                        
                        Spacer()
                    }
                    
                    if !viewModel.isPublicVisibility() {
                        NoticeBanner("게스트 게시물은 공개 범위를 수정할 수 없어요.")
                    }
                }
                .overlay(alignment: .topLeading) {
                    CategoryDropDownView(selectedCategory: $viewModel.category)
                        .onChange(of: viewModel.category) { category in
                            viewModel.updateLog()
                        }
                }
                
            } //~VStack
            .padding(.horizontal, 20)
            .padding(.top, 26)
        } //~ScrollView
        .safeAreaInset(edge: .top, content: {
            HeaderView(
                leadingView: {
                    BackButton {
                        onGoBack()
                    }
                },trailingView: {
                    HStack (alignment: .center, spacing: 4){
                        Button {
                            viewModel.downloadImage()
                        } label: {
                            Image("iconDownload")
                                .renderingMode(.template)
                                .foregroundStyle(Color.gray50)
                                .padding(10)
                        }
                        
                        Button {
                            viewModel.prepareImageForSharing()
                            if viewModel.shareImage != nil {
                                showShareSheet = true
                            }
                        } label: {
                            Image("iconShare")
                                .renderingMode(.template)
                                .foregroundStyle(Color.gray50)
                                .padding(10)
                        }
                        
                        Button {
                            showDeletePopup = true
                        } label: {
                            Image("IconDelete")
                                .renderingMode(.template)
                                .foregroundStyle(Color.gray50)
                                .padding(10)
                        }
                    }
                }
                
            )
            .background(Color.gray900)
        })
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .scrollDismissesKeyboard(.interactively)
        .mainBackgourndColor()
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            if !hasAppeared {
                hasAppeared = true
                viewModel.fetchDetail()
            }
        }
        .popup(isPresented: $showDeletePopup) {
            Modal(title: "사진을 삭제하시겠습니까?")
                .buttons {
                    MainButton(title: "취소", size: .middle, colorType: .secondary) {
                        showDeletePopup = false
                    }
                    MainButton(title: "삭제", size: .middle) {
                        showDeletePopup = false
                        viewModel.deleteLog()
                    }
                }
        }
        .navigationDestination(isPresented: $navigateToEditor) {
            diContainer.makeLogEditorView(log: viewModel.detail) { hasEdited in
                navigateToEditor = false // (닫기)
                if hasEdited {
                    viewModel.fetchDetail()
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = viewModel.shareImage {
                ShareSheet(items: [image], title: "스탬픽 ㅣ 오늘 하루 인증 완료!", showImagePreview: true)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .onChange(of: viewModel.shareImage) { newValue in
            if newValue != nil {
                showShareSheet = true
            }
        }
    }
    
    private var privateTag: some View {
        HStack(spacing: 4){
            Image("lock_line")
                .resizable()
                .frame(width: 16, height: 16)
            Text("비공개")
                .font(.Btn2)
                .foregroundStyle(Color.gray300)
        }
        .padding(.vertical, 10)
    }
    
    private var ellipsisImage: some View {
        Image(systemName: "ellipsis")
            .foregroundStyle(Color.gray50)
            .padding(.vertical, 10.11)
            .padding(.horizontal, 2.53)
    }
    
    private var logImage: some View {
        Group {
            switch viewModel.detail.imageSource {
                
                // MARK: 서버이미지
            case let .remote(remoteImage):
                
                KFImage(URL(string: remoteImage.imageUrl))
                    .placeholder {
                        Placeholder(width: 48, height: 48)
                    }
                    .retry(maxCount: 3, interval: .seconds(2))
                    .cacheMemoryOnly()
                    .onFailure { error in
                        Logger.error("Image load failed: \(error.localizedDescription)")
                    }
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFill()
                
                // MARK: 로컬 이미지
            case let .local(localImage):
                LocalImageView(
                    imageFileName: localImage.imageFileName,
                    targetSize: CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
                )
                
            } //~switch
        }
        .clipped()
        .aspectRatio(1, contentMode: .fill)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .roundedBorder(color: .gray700, radius: 8)
    }
    
    private var LoginRequiredBanner: some View {
        HStack (alignment: .center, spacing: 6){
            Image(systemName: "exclamationmark.circle.fill")
            Text("로그인 전 게시물은 공개 범위를 수정할 수 없어요.")
                .font(.Body2)
            
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.gray500)
        .background(Color.gray800)
        .rounded(radius: 8)
    }
}

#Preview {
    MockMyLogDIContainer().makeLogDetailView(
        log: .init(
            id: UUID(),
            category: .food,
            timeStamp: Date(),
            imageSource: .local(.init(imageFileName: "")),
            visibility: .privateVisible),
        onGoBack: {}
    )
    
}
