//
//  GalleryView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import SwiftUI
import Photos
import Combine

struct GalleryView: View {
    @StateObject var viewModel: GalleryViewModel
    let diContainer: CameraDIContainerProtocol
    let onDismiss: () -> Void

    @State private var navigateToSavePhoto = false

    // 그리드 레이아웃 설정
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    var body: some View {
        ZStack {
            if viewModel.photos.isEmpty {
                emptyView
            } else {
                photoGrid
            }

            // NavigationLink (hidden)
            if let image = viewModel.selectedImage {
                NavigationLink(
                    destination: diContainer.makePhotoSaveView(
                        capturedImage: image,
                        onDismiss: onDismiss,
                        onGoBack: {
                            navigateToSavePhoto = false
                            viewModel.clearSelectedImage()
                        }
                    ),
                    isActive: $navigateToSavePhoto
                ) {
                    EmptyView()
                }
            }
        }
        .loading(viewModel.isLoading)
        .onAppear {
            Task {
                await viewModel.checkAndRequestPermission()
            }
        }
        .alert("사진 접근 권한 필요", isPresented: $viewModel.showPermissionAlert) {
            Button("확인", role: .cancel) { }
            Button("설정으로 이동") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("앨범의 사진을 불러오려면 설정에서 사진 접근 권한을 허용해주세요.")
        }
        .onChange(of: viewModel.selectedImage) { image in
            if image != nil {
                navigateToSavePhoto = true
            }
        }
    }

    // MARK: - Empty View

    private var emptyView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.gray500)

            Text("앨범에 사진이 없습니다")
                .font(.SubTitle2)
                .foregroundColor(.gray300)
            
            Spacer()
        }
    }

    // MARK: - Photo Grid

    private var photoGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(viewModel.photos, id: \.localIdentifier) { asset in
                    PhotoGridCell(asset: asset, useCase: viewModel.useCase) {
                        Task {
                            await viewModel.loadFullImage(from: asset)
                        }
                    }
                }
            }
            .padding(2)
        }
    }
}


#Preview {
    MockCameraDIContainer().makeCameraTabView(onDismiss: {})
}
