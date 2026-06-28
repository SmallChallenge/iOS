//
//  ShareSheet.swift
//  TimeStamp
//
//  Created by 임주희 on 12/30/25.
//

import SwiftUI
import UIKit
import LinkPresentation

// MARK: - Custom Activity Item Source

class ShareActivityItemSource: NSObject, UIActivityItemSource {
    let image: UIImage
    let title: String
    let showImagePreview: Bool

    init(title: String, image: UIImage, showImagePreview: Bool) {
        self.title = title
        self.image = image
        self.showImagePreview = showImagePreview
        super.init()
    }

    // 공유할 실제 데이터 (이미지)
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }

    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return image
    }

    // 이메일 등에서 제목으로 사용
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return title
    }

    // 미리보기 메타데이터 (제목, 설명, 이미지)
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title

        // showImagePreview가 true일 때만 이미지를 미리보기로 설정
        if showImagePreview {
            metadata.imageProvider = NSItemProvider(object: image)
        }

        return metadata
    }
}

// MARK: - ShareSheet

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    let title: String?
    let showImagePreview: Bool

    init(items: [Any], title: String? = nil, showImagePreview: Bool = false) {
        self.items = items
        self.title = title
        self.showImagePreview = showImagePreview
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        var activityItems: [Any] = []

        // title이 있으면 커스텀 ActivityItemSource 사용
        if let firstImage = items.first as? UIImage, let title = title {
            let customItem = ShareActivityItemSource(
                title: title,
                image: firstImage,
                showImagePreview: showImagePreview
            )
            activityItems = [customItem]
        } else {
            // 기본 동작: items를 그대로 사용
            activityItems = items
        }

        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
