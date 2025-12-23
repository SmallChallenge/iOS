//
//  PHAssetImageView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import SwiftUI
import Photos

struct PHAssetImageView: View {
    let assetIdentifier: String
    let targetSize: CGSize

    @State private var image: UIImage?
    @State private var isLoading = true

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if isLoading {
                ProgressView()
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {
        let fetchOptions = PHFetchOptions()
        let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: fetchOptions)

        guard let asset = fetchResult.firstObject else {
            isLoading = false
            print(">>>>> Failed to fetch PHAsset with identifier: \(assetIdentifier)")
            return
        }

        let imageManager = PHImageManager.default()
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = .highQualityFormat
        requestOptions.isNetworkAccessAllowed = true
        requestOptions.isSynchronous = false

        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFill,
            options: requestOptions
        ) { resultImage, info in
            DispatchQueue.main.async {
                if let resultImage = resultImage {
                    self.image = resultImage
                }
                self.isLoading = false
            }
        }
    }
}
