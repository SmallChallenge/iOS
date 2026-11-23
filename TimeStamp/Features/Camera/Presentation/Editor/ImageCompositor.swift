//
//  ImageCompositor.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI
import UIKit

/// 이미지 합성 및 렌더링을 담당하는 서비스
struct ImageCompositor {

    // MARK: - Public Methods

    /// 배경 이미지와 템플릿 오버레이를 합성하여 최종 이미지 생성
    func composeImage<TemplateView: View>(
        backgroundImage: UIImage,
        template: TemplateView
    ) -> UIImage? {
        
        let imageRatio: CameraAspectRatio = (backgroundImage.size.width / backgroundImage.size.height >= 1) ? CameraAspectRatio.square : CameraAspectRatio.threeFour
        let imageWidth: CGFloat = UIScreen.main.bounds.width
        let templateSize = CGSize(
            width: imageWidth,
            height: imageWidth / imageRatio.value
        )
         
        // 1. 비율에 맞춰 중앙 크롭 (원본 해상도 유지)
        guard let croppedImage = cropToAspect(backgroundImage, aspectRatio: imageRatio.value) else {
            return nil
        }

        // 2. 템플릿 오버레이 렌더링
        guard let templateOverlay = renderTemplateView(template: template, size: templateSize) else {
            return nil
        }

        // 3. 두 이미지 합성
        return compose(background: croppedImage, overlay: templateOverlay)
    }

    // MARK: - Private Methods
    
    /// 지정한 비율(가로/세로)로 중앙 크롭
        private func cropToAspect(_ image: UIImage, aspectRatio: CGFloat) -> UIImage? {
            let size = image.size
            let imageRatio = size.width / size.height

            let cropSize: CGSize
            if imageRatio > aspectRatio {
                // 이미지가 더 가로로 넓음 → 좌우를 자름
                cropSize = CGSize(width: size.height * aspectRatio, height: size.height)
            } else {
                // 이미지가 더 세로로 김 → 위아래를 자름
                cropSize = CGSize(width: size.width, height: size.width / aspectRatio)
            }

            let origin = CGPoint(
                x: -(size.width - cropSize.width) / 2,
                y: -(size.height - cropSize.height) / 2
            )

            let format = UIGraphicsImageRendererFormat()
            format.scale = image.scale   // 원본 스케일 유지
            format.opaque = true

            let renderer = UIGraphicsImageRenderer(size: cropSize, format: format)
            return renderer.image { _ in
                image.draw(at: origin)   // draw는 imageOrientation도 알아서 처리
            }
        }
    
    /// 이미지를 정사각형으로 크롭 (scaledToFill 효과)
    private func cropToSquare(_ image: UIImage, targetSize: CGSize) -> UIImage? {
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

    /// 템플릿 뷰를 UIImage로 렌더링 (iOS 16+ ImageRenderer 사용)
    @MainActor
    private func renderTemplateView<TemplateView: View>(
        template: TemplateView,
        size: CGSize
    ) -> UIImage? {
        let templateView = template
            .frame(width: size.width, height: size.height)
            .ignoresSafeArea()

        let renderer = ImageRenderer(content: templateView)
        renderer.proposedSize = ProposedViewSize(size)
        renderer.scale = UIScreen.main.scale

        return renderer.uiImage
    }

    /// 배경과 오버레이 합성    
    private func compose(background: UIImage, overlay: UIImage) -> UIImage? {
            let format = UIGraphicsImageRendererFormat()
            format.scale = background.scale   // 원본 해상도 유지
            format.opaque = true

            let rect = CGRect(origin: .zero, size: background.size)
            let renderer = UIGraphicsImageRenderer(size: background.size, format: format)
            return renderer.image { _ in
                background.draw(in: rect)
                overlay.draw(in: rect)   // 오버레이를 배경 크기에 맞춰 스케일
            }
        }
}
