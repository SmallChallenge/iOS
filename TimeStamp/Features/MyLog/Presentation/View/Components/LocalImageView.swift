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
                Color.gray400
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray500)
                    }
            }
        }
        .onAppear {
            loadImage()
        }
    }

    /// Documents 디렉토리에서 이미지 로드
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

        // 이미지 로드
        if let loadedImage = UIImage(contentsOfFile: fileURL.path) {
            self.image = loadedImage
            Logger.debug("이미지 로드 성공: \(imageFileName)")
        } else {
            Logger.error("이미지 로드 실패: \(imageFileName)")
        }

        isLoading = false
    }
}

#Preview {
    LocalImageView(imageFileName: "test.jpg")
        .frame(width: 120, height: 120)
}
