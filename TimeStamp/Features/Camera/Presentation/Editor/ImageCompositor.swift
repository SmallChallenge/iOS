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
        background: UIImage,
        template: TemplateView,
        templateSize: CGSize
    ) -> UIImage? {
        // 1. 배경 이미지를 정사각형으로 크롭
        guard let croppedBackground = cropToSquare(background, targetSize: templateSize) else {
            return nil
        }

        // 2. 템플릿 오버레이 렌더링
        guard let templateOverlay = renderTemplateView(template: template, size: templateSize) else {
            return nil
        }

        // 3. 두 이미지 합성
        return compose(background: croppedBackground, overlay: templateOverlay)
    }

    // MARK: - Private Methods

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
            .frame(width: size.width, height: size.height, alignment: .center)
            .ignoresSafeArea()

        let renderer = ImageRenderer(content: templateView)
        renderer.proposedSize = ProposedViewSize(size)
        renderer.scale = UIScreen.main.scale

        return renderer.uiImage
    }

    /// 배경과 오버레이 합성
    private func compose(background: UIImage, overlay: UIImage) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: background.size)
        return renderer.image { context in
            background.draw(at: .zero)
            overlay.draw(at: .zero)
        }
    }
}
