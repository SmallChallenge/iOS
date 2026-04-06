//
//  LogEditorView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import SwiftUI
import Kingfisher
import Combine


struct LogEditorView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: LogEditorViewModel
    let onDismiss: (_ hasEdited: Bool) -> Void
    init(viewModel: LogEditorViewModel, onDismiss: @escaping (_ hasEdited: Bool) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading, spacing: 0){
                // 이미지 뷰
                logImage
                    //.aspectRatio(1, contentMode: .fit)
                    .padding(.top, 20)
                    
                Spacer()
                    .frame(height: 32)
                
                // 카테고리 선택
                categoryPicker
                    
                
                Spacer()
                    .frame(height: 40)

                // 공개여부 선택
                visibilityPicker
                
                if viewModel.isPublicVisibility() {
                    Text("👆전체 공개 설정하고 커뮤니티 활동을 시작해보세요!")
                        .font(.Body2)
                        .foregroundStyle(Color.gray500)
                        .padding(.top, 8)
                } else {
                    NoticeBanner("게스트 게시물은 공개 범위를 수정할 수 없어요.")
                        .padding(.top, 16)
                }
                
                
            }// ~Vstack
            .padding(.horizontal, 20)
        }// ~Scrollview
        .safeAreaInset(edge: .top, content: {
            // 헤더
            HeaderView(
                leadingView: {
                    BackButton {
                        onDismiss(viewModel.hasEdited)
                    }
                    
                }, trailingView: {
                    MainButton(title: "완료", size: .small) {
                        viewModel.editLog()
                    }
                    .disabled(viewModel.isLoading)
                    .padding(.trailing, 20)
                })
            .background(Color.gray900)
        })
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .mainBackgourndColor()
        .toast(message: $viewModel.toastMessage)
        .onChange(of: viewModel.hasEdited) { hasEdited in
            if hasEdited{ // 수정완료
                ToastManager.shared.show(AppMessage.editSuccess.text)
                onDismiss(hasEdited)
            }
        }
    }
    
    private var logImage: some View {
        Group {
            switch viewModel.log.imageSource {

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
        .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .roundedBorder(color: .gray700, radius: 8)
    }
    
    
    // 카테고리 선택
    var categoryPicker: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("카테고리 선택")
                    .font(.SubTitle2)
                    .foregroundStyle(.gray50)
            }
            
            HStack(alignment: .center, spacing: 8){
                ForEach(CategoryViewData.allCases, id: \.self) { category in
                    CategoryButton(
                        type: category,
                        state: {
                            viewModel.selectedCategory == category ? .selected : .unselected
                        }()
                    ) {
                        viewModel.selectedCategory = category
                    }
                }
                
                Spacer()
            }
        }
    }
    
    
    /// 공개여부 선택
    var visibilityPicker: some View {
        VStack(alignment: .leading, spacing: 012) {
            HStack(spacing: 8){
                Text("공개 여부 선택")
                    .font(.SubTitle2)
                    .foregroundStyle(.gray50)
            }
            
            HStack(spacing: 8){
                if viewModel.isPublicVisibility() {
                    // [전체 공개]버튼
                    TagButton(
                        title: VisibilityViewData.publicVisible.title,
                        isActive: viewModel.selectedVisibility == .publicVisible) {
                            viewModel.selectedVisibility = .publicVisible
                        }
                }
                
                // [비공개]버튼
                TagButton(
                    title: VisibilityViewData.privateVisible.title,
                    isActive: viewModel.selectedVisibility == .privateVisible) {
                        viewModel.selectedVisibility = .privateVisible
                    }
            }
        }
    }
}

#Preview {
    class MockLogEditorUseCase: LogEditorUseCaseProtocol {
        func editLogForServer(logId: Int, category: Category, visibility: VisibilityType) async throws -> EditLog {
            return EditLog(
                imageId: logId,
                category: category,
                visibility: visibility,
                visibilityChanged: false,
                updatedAt: Date(),
                publishedAt: Date()
            )
        }

        func editLogForLocal(logId: UUID, category: Category, visibility: VisibilityType) throws {
            // Mock: 아무것도 하지 않음
        }
    }

    return LogEditorView(
        viewModel: LogEditorViewModel(
            log: .init(
                id: UUID(),
                category: .food,
                timeStamp: Date(),
                imageSource: .remote(TimeStampLog.RemoteTimeStampImage(
                    id: 0,
                    imageUrl: "https://picsum.photos/400/400"
                )),
                visibility: .privateVisible
            ),
            useCase: MockLogEditorUseCase()
        ),
        onDismiss: {hasEdited in }
    )
}

