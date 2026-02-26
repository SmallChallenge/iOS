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
    }
    
    // MARK: prevate property

    @State private var selectedTemplateStyle: TemplateStyleViewData = .basic
    @State private var selectedTemplate: Template = Template.all[0]
    
    @State private var showLoginView: Bool = false
    @State private var navigateToPhotoSave = false
    @State private var editedImage: UIImage?

    private let imageCompositor = ImageCompositor()

    /// 선택된 스타일에 맞는 템플릿 필터링
    private var filteredTemplates: [Template] {
        Template.all.filter { $0.style == selectedTemplateStyle }
    }
    
    var body: some View {
        ZStack {
            VStack (alignment: .center, spacing: .zero){
                
                // 헤더
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
                
                
                // 사진 화면
                VStack (alignment: .center, spacing: .zero){
                    
                    Spacer()
                        .frame(maxHeight: 40)
                        .layoutPriority(-2)
                    
                    // 이미지뷰
                    editedImageView()
                        .layoutPriority(1)
                    
                    Spacer()
                        .frame(maxHeight: 56)
                        .layoutPriority(-2)
                }

                // 템플릿 선택 뷰
                VStack(alignment: .leading, spacing: 24) {

                    // 템플릿스타일 | 로고 스위치
                    HStack {
                        // 스타일 버튼 목록
                        templateStyleSelectorView

                        Spacer()

                        // 로고 스위치
                        logoToggle
                    }
                    .padding(.horizontal, 20)

                    // 템플릿 목록
                    templateList

                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                    .layoutPriority(-1)
                
            } // ~VStack

            // 광고 로딩 중 오버레이
//            if viewModel.isLoadingAd {
//                Color.black.opacity(0.4)
//                    .ignoresSafeArea()
//
//                VStack(spacing: 16) {
//                    ProgressView()
//                        .scaleEffect(1.5)
//                        .tint(.white)
//
//                    Text("광고를 불러오는 중...")
//                        .font(.Body1)
//                        .foregroundColor(.white)
//                }
//            }
        } // ~ZStack
        .mainBackgourndColor()
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
//        .task {
//            await viewModel.loadAd()
//        }
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
       
        /*
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
        })*/
        .navigationDestination(isPresented: $navigateToPhotoSave) {
            if let editedImage = editedImage {
                diContainer.makePhotoSaveView(
                    capturedImage: editedImage,
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
                    selectedTemplateStyle = type
                } label: {
                    Text(type.name)
                        .font(type == selectedTemplateStyle ? .Btn2_b : .Btn2)
                        .foregroundColor(type == selectedTemplateStyle ? Color.gray50 : Color.gray500)
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
    
    @ViewBuilder
    private func editedImageView() -> some View {
        ZStack {
            Color.gray500
                .overlay {
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                }
                .clipShape(Rectangle())

            // 템플릿 (타임스탬프, 로고)
            selectedTemplate.makeView(displayDate: photoDate, hasLogo: viewModel.isOnLogo)
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    /// 필터링된 템플릿 목록
    private var templateList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(filteredTemplates) { template in
                    TemplateButton(
                        capturedImage: nil,
                        template: template,
                        isSelected: selectedTemplate == template
                    ) {
                        selectedTemplate = template
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
        let imageSize: CGFloat = UIScreen.main.bounds.width
        let targetSize = CGSize(width: imageSize, height: imageSize)

        guard let composedImage = imageCompositor.composeImage(
            background: capturedImage,
            template: selectedTemplate.makeView(displayDate: capturedDate, hasLogo: viewModel.isOnLogo),
            templateSize: targetSize
        ) else {
            return
        }

        editedImage = composedImage
        navigateToPhotoSave = true
    }
    
}

#Preview {
    MockCameraDIContainer().makeEditorView(capturedImage: UIImage(named: "sampleImage")!, capturedDate: Date(), onGoBack: {}, onComplete: {})
}
