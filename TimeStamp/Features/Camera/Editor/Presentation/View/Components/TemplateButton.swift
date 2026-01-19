//
//  TemplateButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI

/// 템플릿 선택 버튼 (템플릿 썸네일)뷰
struct TemplateButton: View {
    let capturedImage: UIImage?
    let template: Template
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Image(template.name)
            .resizable()
            .frame(width: 90, height: 90)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(8)
            .roundedBorder(
                color: isSelected ? Color.gray50 : Color.gray700,
                radius: 8,
                lineWidth: isSelected ? 2 : 1
            )
            .onTapGesture {
                action()
            }
        
    }
}

#Preview {
    HStack(spacing: 8) {
        TemplateButton(
            capturedImage: UIImage(named: "Basic3Template"),
            template: Template(
                style: .basic,
                name: "Basic3Template",
                viewBuilder: { _,_ in AnyView(EmptyView())}
            ),
            isSelected: true
        ) {}

        
    }
}
