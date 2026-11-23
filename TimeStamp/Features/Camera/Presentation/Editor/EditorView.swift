//
//  EditorView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import SwiftUI
import Combine

struct EditorView: View {
    @StateObject private var viewModel: EditorViewModel
    let capturedImage: UIImage
    let capturedDate: Date // 갤러리에서 가져온 경우 PHAsset의 날짜, nil이면 Date()생성
    let diContainer: CameraDIContainerProtocol
    let onGoBack: (() -> Void)?
    let onComplete: () -> Void
    
    init(viewModel: EditorViewModel,
         capturedImage: UIImage,
         capturedDate: Date,
         diContainer: CameraDIContainerProtocol,
         onGoBack: (() -> Void)?,
         onComplete: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.capturedImage = capturedImage
        self.capturedDate = capturedDate
        self.diContainer = diContainer
        self.onGoBack = onGoBack
        self.onComplete = onComplete
        self.imageRatio = (capturedImage.size.width / capturedImage.size.height >= 1) ? CameraAspectRatio.square : CameraAspectRatio.threeFour
    }
    
    // MARK: prevate property
    
    @State private var showLoginView: Bool = false
    @State private var navigateToPhotoSave = false
    @State private var editedImage: UIImage?
    private let imageRatio: CameraAspectRatio

    private let imageCompositor = ImageCompositor()

    /// 선택된 스타일에 맞는 템플릿 필터링
    private var filteredTemplates: [Template] {
        switch viewModel.selectedTemplateStyle {
        case .favorite:
            return Template.all.filter { viewModel.favoriteTemplateIds.contains($0.templateId)}
        default:
            return Template.all.filter { $0.style == viewModel.selectedTemplateStyle }
        }
    }
    
    /// 첫 진입인지 확인
    @State private var isFirstAppear: Bool = true
    
    var body: some View {
        ZStack {
            VStack (alignment: .center, spacing: .zero){
                
                // MARK: 헤더
                HeaderView(leadingView: {
                    // 뒤로가기 버튼
                    BackButton {
                        onGoBack?()
                    }
                }, trailingView: {
                    // 다음 버튼 (사진저장화면으로)
                    MainButton(title: "다음", size: .small) {
                        captureEditedImage()
                    }
                    .padding(.trailing, 20)
                })
                
                if imageRatio == .square {
                    Spacer(minLength: 0)
                        .frame(minHeight: 0, maxHeight: 40)
                }

                
                // MARK: 사진 화면 (사진+템플릿)
                    editedImageView()
                
                Spacer()
                    .frame(minHeight: 0, maxHeight: 30)
                    .layoutPriority(-1)

                // MARK: 템플릿 선택 뷰
                VStack(alignment: .leading, spacing: .zero) {
                
                    // 템플릿 카테고리(스타일) + 로고 온오프
                    VStack(alignment: .leading, spacing: .zero) {
                        Spacer()
                            .frame(minHeight: 12, maxHeight: 24)
                        
                        // 템플릿 스타일 | 로고 스위치
                        HStack {
                            // 스타일 버튼 목록
                            templateStyleSelectorView
                            Spacer()
                            // 로고 스위치
                            logoToggle
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(minHeight: 10, maxHeight: 22)

                    }

                    // 템플릿 목록
                    if  viewModel.selectedTemplateStyle == .favorite && filteredTemplates.isEmpty {
                        //즐겨찾기 목록이 없을 경우
                        emptyFavorite
                    } else {
                        // 템플릿 목록
                        templateList
                    }
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                    
                
            } // ~VStack

            // 광고 로딩 중 오버레이
            if viewModel.isLoadingAd {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.5)
                            .tint(.white)
                        
                        Text("광고를 불러오는 중...")
                            .font(.Body1)
                            .foregroundColor(.white)
                    }
                }
            }
        } // ~ZStack
        .mainBackgourndColor()
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear(perform: {
            guard isFirstAppear else { return }
            isFirstAppear = false
            AmplitudeManager.shared.trackEditorViewEnter()
        })
        .task {
            viewModel.getFavoriteTemplateIds()
            viewModel.getLastSelectedTemplate()
            
            // 광고 미리 준비
            await viewModel.loadAd()
        }
        .toast(message: $viewModel.toastMessage)
        // 로그인 팝업 띄우기
        .popup(isPresented: $viewModel.showLoginPopup, content: {
            Modal(title: AppMessage.loginRequired.text)
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        viewModel.showLoginPopup = false
                    }
                    MainButton(title: "로그인", colorType: .primary) {
                        // 로그인 화면 띄우기
                        viewModel.showLoginPopup = false
                        showLoginView = true
                    }
                }
        })
       
        // 광고 시청 팝업 띄우기
        .popup(isPresented: $viewModel.showAdPopup, content: {
            Modal(title: "광고 시청 후\n워터마크를 제거하세요.")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        viewModel.closeAdPopup()
                    }
                    MainButton(title: "광고 시청", colorType: .primary) {
                        //광고 시청
                        viewModel.closeAdPopup()
                        Task {
                            // 팝업이 사라질 시간을 아주 잠깐(0.1초) 줍니다.
                            try? await Task.sleep(nanoseconds: 100_000_000)
                            await viewModel.playAd()
                        }
                    }
                }
        })
        .navigationDestination(isPresented: $navigateToPhotoSave) {
            // 수정 화면으로 넘기기
            if let editedImage = editedImage {
                diContainer.makePhotoSaveView(
                    capturedImage: editedImage,
                    selectedTemplateStyle: viewModel.selectedTemplateStyle.enName,
                    selectedTamplateId: viewModel.selectedTemplate.templateId,
                    onGoBack: nil,
                    onComplete: onComplete
                )
            }
        }
        // 로그인 화면 띄우기
        .fullScreenCover(isPresented: $showLoginView, content: {
            AppDIContainer.shared.makeLoginView {
                showLoginView = false
            }
        })
        
    }
    
    // MARK: - Subviews

    var templateStyleSelectorView: some View {
        HStack (spacing: 16){
            ForEach(TemplateStyleViewData.allCases, id: \.self) { type in
                Button {
                    viewModel.selectedTemplateStyle = type
                } label: {
                    Text(type.name)
                        .font(type == viewModel.selectedTemplateStyle ? .Btn2_b : .Btn2)
                        .foregroundColor(type == viewModel.selectedTemplateStyle ? Color.gray50 : Color.gray500)
                }
            }
        }
    }
    
    var logoToggle: some View {
        HStack(spacing: 6){
            Text("Logo")
                .font(.Body2)
                .foregroundStyle(Color.gray300)
            
            
            Toggle("Logo", isOn: $viewModel.isOnLogo)
                .labelsHidden()
                .fixedSize()
                .allowsHitTesting(false)
                .overlay {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.handleLogoToggleTap()
                        }
                }
        }
    }
    
    // 사진 화면 (사진+템플릿)
    @ViewBuilder
    private func editedImageView() -> some View {
        ZStack {
            // 원본사진
            Color.gray500
                .aspectRatio(imageRatio.value, contentMode: .fit)
                .overlay {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .aspectRatio(imageRatio.value, contentMode: .fit)
                        .clipped()
                }
                .clipShape(Rectangle())
                .contentShape(Rectangle())
            
            // 템플릿 (타임스탬프, 로고)
            viewModel.selectedTemplate.makeView(displayDate: capturedDate, hasLogo: viewModel.isOnLogo)
                .aspectRatio(imageRatio.value, contentMode: .fit)
        } //ZStack
        .frame(maxWidth: .infinity)
        .layoutPriority(1)
            
    }
    
    /// 즐겨찾기 비어있음 empty뷰
    private var emptyFavorite: some View {
        ZStack {
            TemplateButton(capturedImage: nil, template: Template.all[0], isSelected: false, isFavorite: false, action: {})
                .padding(.vertical, 3)
                .hidden()
            
            HStack (alignment: .center){
                Spacer()
                Text("자주 사용하는 템플릿은\n꾹 눌러 즐겨찾기에 추가해 보세요.")
                    .font(.Body2)
                    .foregroundStyle(.gray500)
                    .padding(.vertical, 12)
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
    }
    
    /// 필터링된 템플릿 목록
    private var templateList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filteredTemplates) { template in
                    TemplateButton(
                        capturedImage: nil,
                        template: template,
                        isSelected: viewModel.selectedTemplate == template,
                        isFavorite: viewModel.favoriteTemplateIds.contains(template.templateId)
                    ) {
                        // 템플릿 선택
                        viewModel.selectedTemplate = template
                        viewModel.saveSelectedTemplate()
                        AmplitudeManager.shared.trackTemplateSelection(
                            templateId: template.templateId,
                            templateCategory: viewModel.selectedTemplateStyle.enName
                        )
                    }
                    .onLongPressGesture {
                        // 햅틱
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                        
                        // 즐겨찾기 넣기 Or 빼기
                        if viewModel.favoriteTemplateIds.contains(template.templateId) {
                            viewModel.removeFavoriteTemplate(id: template.templateId)
                        } else {
                            viewModel.addFavoriteTemplate(id: template.templateId)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 3)
        }
    }
    
    // MARK: - Functions
    
    /// 이미지 렌더해서 뽑아내기
    @MainActor
    private func captureEditedImage() {
        guard let composedImage = imageCompositor.composeImage(
            backgroundImage: capturedImage,
            template: viewModel.selectedTemplate.makeView(
                displayDate: capturedDate,
                hasLogo: viewModel.isOnLogo
            )
        ) else {
            viewModel.toastMessage = AppMessage.saveFailed.text
            return
        }

        editedImage = composedImage
        navigateToPhotoSave = true
    }
    
}

#Preview {
    MockCameraDIContainer().makeEditorView(capturedImage: UIImage(named: "sampleImage2")!, capturedDate: Date(), onGoBack: {}, onComplete: {})
}
