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

    private let imageCompositor = ImageCompositor()

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

        guard let composedImage = imageCompositor.composeImage(
            background: capturedImage,
            template: DefaultTemplateView(),
            templateSize: targetSize
        ) else {
            return
        }

        editedImage = composedImage
        navigateToPhotoSave = true
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
