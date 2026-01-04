//
//  EditorView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import SwiftUI
import Combine

struct EditorView: View {

    let capturedImage: UIImage
    let capturedDate: Date? // 갤러리에서 가져온 경우 PHAsset의 날짜, nil이면 Date()생성
    let diContainer: CameraDIContainerProtocol
    let onGoBack: (() -> Void)?
    let onDismiss: () -> Void
    
    // MARK: prevate property

    @State private var selectedTemplateStyle: TemplateStyleViewData = .basic
    @State private var selectedTemplate: Template = Template.all[0]
    
    // 광고, 로고 여부 //
    @State private var showAdPopup: Bool = false // 광고보기 팝업 띄우기
    @State private var isOnLogo: Bool = true // 로고 여부
    @State private var hasWatchedAd: Bool  = false // 광고시청여부
    
    
    @State private var navigateToPhotoSave = false
    @State private var editedImage: UIImage?

    private let imageCompositor = ImageCompositor()

    /// 실제 촬영/생성 날짜
    private var photoDate: Date {
        // from 갤러리: PHAsset.creationDate
        // from 카메라: 현재 시간
        capturedDate ?? Date()
    }

    /// 선택된 스타일에 맞는 템플릿 필터링
    private var filteredTemplates: [Template] {
        Template.all.filter { $0.style == selectedTemplateStyle }
    }
    
    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 0){

                Spacer()
                    .frame(maxHeight: 40)

                // 이미지뷰
                editedImageView()

                Spacer()
                    .frame(maxHeight: 56)
                
                // 템플릿 선택 뷰
                VStack(spacing: 24) {
                    
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
            } // ~VStack
        } // ~ZStack
        .navigationDestination(isPresented: $navigateToPhotoSave) {
            if let editedImage = editedImage {
                diContainer.makePhotoSaveView(
                    capturedImage: editedImage,
                    onGoBack: {
                        navigateToPhotoSave = false
                    },
                    onDismiss: onDismiss
                )
            }
        }
        .mainBackgourndColor()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                // 뒤로가기 버튼
                BackButton {
                    onGoBack?()
                }
            }
            
            // 다음 버튼 (사진저장화면으로)
            ToolbarItem(placement: .navigationBarTrailing) {
                MainButton(title: "다음", size: .small) {
                    captureEditedImage()
                }
            }
        }
        // 광고 시청 팝업 띄우기
        .popup(isPresented: $showAdPopup, content: {
            Modal(title: "광고 시청 후\n워터마크를 제거하세요.")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        showAdPopup = false
                    }
                    MainButton(title: "광고 시청", colorType: .primary) {
                        // TODO: 광고 시청
                        hasWatchedAd = true
                        isOnLogo = false
                        showAdPopup = false
                        
                    }
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
            
            
            Toggle("Logo", isOn: $isOnLogo)
                .labelsHidden()
                .fixedSize()
                .allowsHitTesting(false)
                .overlay {
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            handleLogoToggleTap()
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
            selectedTemplate.makeView(displayDate: photoDate, hasLogo: isOnLogo)
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
            template: selectedTemplate.makeView(displayDate: photoDate, hasLogo: isOnLogo),
            templateSize: targetSize
        ) else {
            return
        }

        editedImage = composedImage
        navigateToPhotoSave = true
    }
    
    /// 로고 토글 탭 이벤트 처리
    private func handleLogoToggleTap() {
        // 광고 시청 완료: 자유롭게 설정가능
        guard !hasWatchedAd else {
            isOnLogo = !isOnLogo
            return
        }
        
        // 광고 미시청: 로고 없애려면 광고보기 팝업띄우기
        if isOnLogo {
            showAdPopup = true
        }
    }
    

}

#Preview {
    EditorView(
        capturedImage: UIImage(named: "sampleImage")!,
        capturedDate: Date(),
        diContainer: MockCameraDIContainer(),
        onGoBack: nil,
        onDismiss: {}
    )
}
