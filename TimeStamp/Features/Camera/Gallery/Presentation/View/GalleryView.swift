//
//  GalleryView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import SwiftUI
import Photos

struct GalleryView: View {
    let diContainer: CameraDIContainerProtocol
    let onDismiss: () -> Void

    @State private var photos: [PHAsset] = []
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToSavePhoto = false
    @State private var showPermissionAlert = false
    @State private var hasRequestedPermission = false

    // 그리드 레이아웃 설정
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    var body: some View {
        ZStack {
            if photos.isEmpty {
                emptyView
            } else {
                photoGrid
            }

            // NavigationLink (hidden)
            if let image = selectedImage {
                NavigationLink(
                    destination: diContainer.makePhotoSaveView(
                        capturedImage: image,
                        onDismiss: onDismiss,
                        onGoBack: {
                            navigateToSavePhoto = false
                            selectedImage = nil
                        }
                    ),
                    isActive: $navigateToSavePhoto
                ) {
                    EmptyView()
                }
            }
        }
        .onAppear {
            checkPhotoLibraryPermission()
        }
        .alert("사진 접근 권한 필요", isPresented: $showPermissionAlert) {
            Button("확인", role: .cancel) { }
            Button("설정으로 이동") {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
        } message: {
            Text("앨범의 사진을 불러오려면 설정에서 사진 접근 권한을 허용해주세요.")
        }
    }

    // MARK: - Empty View

    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "photo.on.rectangle.angled")
                .font(.system(size: 60))
                .foregroundColor(.gray500)

            Text("앨범에 사진이 없습니다")
                .font(.SubTitle2)
                .foregroundColor(.gray300)
        }
    }

    // MARK: - Photo Grid

    private var photoGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(photos, id: \.localIdentifier) { asset in
                    PhotoGridCell(asset: asset) {
                        loadFullImage(from: asset)
                    }
                }
            }
            .padding(2)
        }
    }

    // MARK: - Photo Library Permission

    private func checkPhotoLibraryPermission() {
        guard !hasRequestedPermission else { return }
        hasRequestedPermission = true

        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)

        switch status {
        case .authorized, .limited:
            loadPhotos()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        loadPhotos()
                    } else {
                        showPermissionAlert = true
                    }
                }
            }
        case .denied, .restricted:
            showPermissionAlert = true
        @unknown default:
            showPermissionAlert = true
        }
    }

    // MARK: - Load Photos

    private func loadPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]

        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)

        var assets: [PHAsset] = []
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }

        DispatchQueue.main.async {
            self.photos = assets
        }
    }

    // MARK: - Load Full Image

    private func loadFullImage(from asset: PHAsset) {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = false

        // 1:1 정사각형으로 크롭
        let targetSize = CGSize(width: 1080, height: 1080)

        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: requestOptions
        ) { image, _ in
            if let image = image {
                DispatchQueue.main.async {
                    self.selectedImage = image
                    self.navigateToSavePhoto = true
                }
            }
        }
    }
}

// MARK: - Photo Grid Cell

struct PhotoGridCell: View {
    let asset: PHAsset
    let onTap: () -> Void

    @State private var image: UIImage?
    @State private var isLoading = true

    var body: some View {
        GeometryReader { geometry in
            Button(action: onTap) {
                Group {
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else if isLoading {
                        Color.gray700
                            .overlay {
                                ProgressView()
                                    .tint(.gray300)
                            }
                    } else {
                        Color.gray700
                            .overlay {
                                Image(systemName: "photo")
                                    .foregroundColor(.gray500)
                            }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.width)
                .clipped()
            }
            .buttonStyle(PlainButtonStyle())
        }
        .aspectRatio(1, contentMode: .fit)
        .onAppear {
            loadThumbnail()
        }
    }

    private func loadThumbnail() {
        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .opportunistic
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = false

        let targetSize = CGSize(width: 300, height: 300)

        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: requestOptions
        ) { resultImage, _ in
            DispatchQueue.main.async {
                if let resultImage = resultImage {
                    self.image = resultImage
                }
                self.isLoading = false
            }
        }
    }
}

#Preview {
    MockCameraDIContainer().makeCameraTabView(onDismiss: {})
}
