//
//  LocalImageView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import SwiftUI

/// Documents 디렉토리에 저장된 로컬 이미지를 표시하는 뷰
struct LocalImageView: View {
    let imageFileName: String
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
                // 이미지 로드 실패
                Placeholder()
            }
        }
        .onAppear {
            loadImage()
        }
    }

    /// Documents 디렉토리에서 이미지를 다운샘플링하여 로드
    private func loadImage() {
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            isLoading = false
            Logger.error("Documents 디렉토리를 찾을 수 없습니다.")
            return
        }

        let fileURL = documentsDirectory.appendingPathComponent(imageFileName)

        // 파일이 존재하는지 확인
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            isLoading = false
            Logger.error("이미지 파일을 찾을 수 없습니다: \(imageFileName)")
            return
        }

        // 다운샘플링하여 이미지 로드
        if let downsampledImage = downsampleImage(from: fileURL, to: targetSize) {
            self.image = downsampledImage
            Logger.debug("이미지 로드 성공: \(imageFileName)")
        } else {
            Logger.error("이미지 로드 실패: \(imageFileName)")
        }

        isLoading = false
    }

    /// 메모리 효율적인 이미지 다운샘플링
    private func downsampleImage(from imageURL: URL, to targetSize: CGSize) -> UIImage? {
        let scale = UIScreen.main.scale
        let maxDimensionInPixels = max(targetSize.width, targetSize.height) * scale

        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }

        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary

        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }

        return UIImage(cgImage: downsampledImage)
    }
}

#Preview {
    LocalImageView(imageFileName: "test.jpg", targetSize: CGSize(width: 120, height: 120))
        .frame(width: 120, height: 120)
}
