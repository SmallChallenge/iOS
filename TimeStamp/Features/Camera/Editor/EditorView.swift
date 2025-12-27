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
    let diContainer: CameraDIContainerProtocol
    let onGoBack: (() -> Void)?
    let onDismiss: () -> Void
    
    
    
    @State private var showAdPopup: Bool = false
    @State private var selectedCategory: CategoryFilterViewData = .all
    @State private var isOnLogo: Bool = false
    @State private var navigateToPhotoSave = false
    @State private var editedImage: UIImage?
    
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
                    
                    // 카테고리 | 로고 스위치
                    HStack {
                        // 카테고리 목록
                        categoryTab
                        
                        Spacer()
                        
                        // 로고 스위치
                        logoToggle
                    }
                    .padding(.horizontal, 20)
                    
                    
                    // 템플릿 스크롤
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            Color.gray300
                                .cornerRadius(8)
                                .roundedBorder(color: Color.gray700, radius: 8)
                                .frame(width: 90, height: 90)
                            
                            Color.gray300
                                .cornerRadius(8)
                                .roundedBorder(color: Color.gray700, radius: 8)
                                .frame(width: 90, height: 90)
                            
                        }
                        .padding(.horizontal, 20)
                    }
                }
            } // ~VStack
            
            // NavigationLink (hidden)
            if let editedImage = editedImage {
                NavigationLink(
                    destination: diContainer.makePhotoSaveView(
                        capturedImage: editedImage,
                        onGoBack: {
                            navigateToPhotoSave = false
                        },
                        onDismiss: onDismiss
                    ),
                    isActive: $navigateToPhotoSave
                ) {
                    EmptyView()
                }
            }
            
        } // ~ZStack
        .mainBackgourndColor()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    onGoBack?()
                }
            }
            
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
                        showAdPopup = false
                        // TODO: 광고 시청
                    }
                }
        })
    }
    
    // MARK: - Subviews

    var categoryTab: some View {
        HStack (spacing: 16){
            ForEach(CategoryFilterViewData.allCases, id: \.self) { category in
                Button {
                    selectedCategory = category
                } label: {
                    Text(category.title)
                        .font(.Btn2_b)
                        .foregroundColor(category == selectedCategory ? Color.gray50 : Color.gray500)
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

            // 오버레이 뷰 (타임스탬프, 로고)
            DefaultTemplateView()
        }
        .aspectRatio(1, contentMode: .fit)
    }
    
    
    // MARK: - Functions

    @MainActor
    private func captureEditedImage() {
        let imageSize: CGFloat = UIScreen.main.bounds.width
        let targetSize = CGSize(width: imageSize, height: imageSize)

        // 1. 배경 이미지 렌더링 (정사각형으로 크롭)
        guard let croppedBackground = cropImageToSquare(capturedImage, targetSize: targetSize) else {
            return
        }

        // 2. 템플릿 오버레이 렌더링
        guard let templateOverlay = renderTemplateView(size: targetSize) else {
            return
        }

        // 3. 두 이미지 합성
        guard let composedImage = composeImages(background: croppedBackground, overlay: templateOverlay) else {
            return
        }

        editedImage = composedImage
        navigateToPhotoSave = true
    }

    // 이미지를 정사각형으로 크롭 (scaledToFill 효과)
    private func cropImageToSquare(_ image: UIImage, targetSize: CGSize) -> UIImage? {
        let scale = max(targetSize.width / image.size.width, targetSize.height / image.size.height)
        let scaledSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let xOffset = (scaledSize.width - targetSize.width) / 2
        let yOffset = (scaledSize.height - targetSize.height) / 2

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { context in
            // 회색 배경
            UIColor(Color.gray500).setFill()
            context.fill(CGRect(origin: .zero, size: targetSize))

            // 이미지 그리기
            let drawRect = CGRect(x: -xOffset, y: -yOffset, width: scaledSize.width, height: scaledSize.height)
            image.draw(in: drawRect)
        }
    }

    // 템플릿 뷰를 UIImage로 렌더링
    private func renderTemplateView(size: CGSize) -> UIImage? {
        let templateView = DefaultTemplateView()
            .frame(width: size.width, height: size.height, alignment: .center)
            .ignoresSafeArea()

        let controller = UIHostingController(rootView: templateView)

        // Window에 추가하여 정확한 레이아웃 보장
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = controller
        window.isHidden = false

        controller.view.frame = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear

        // 강제 레이아웃
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        // 약간의 지연
        Thread.sleep(forTimeInterval: 0.05)

        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            controller.view.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        }

        // Window 정리
        window.isHidden = true

        return image
    }

    // 배경과 오버레이 합성
    private func composeImages(background: UIImage, overlay: UIImage) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: background.size)
        return renderer.image { context in
            background.draw(at: .zero)
            overlay.draw(at: .zero)
        }
    }

}

#Preview {
    EditorView(
        capturedImage: UIImage(named: "sampleImage")!,
        diContainer: MockCameraDIContainer(),
        onGoBack: nil,
        onDismiss: {}
    )
}
