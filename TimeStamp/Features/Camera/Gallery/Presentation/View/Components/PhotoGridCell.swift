//
//  PhotoGridCell.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation
import SwiftUI
import Photos

struct PhotoGridCell: View {
    let asset: PHAsset
    let useCase: GalleryUseCaseProtocol
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
        .task {
            await loadThumbnail()
        }
    }

    private func loadThumbnail() async {
        isLoading = true
        image = await useCase.loadThumbnail(from: asset)
        isLoading = false
    }
}
