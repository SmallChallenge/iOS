//
//  TemplateButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI

/// 템플릿 선택 버튼
struct TemplateButton: View {
    let template: Template
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            // TODO: 템플릿 썸네일 표시
            ZStack {
                Color.gray300

                Text(template.name)
                    .font(.caption)
                    .foregroundColor(.gray50)
            }
            .cornerRadius(8)
            .roundedBorder(
                color: isSelected ? Color.gray50 : Color.gray700,
                radius: 8,
                lineWidth: 1
            )
            .frame(width: 90, height: 90)
        }
    }
}

#Preview {
    HStack(spacing: 8) {
        TemplateButton(
            template: Template.all[0],
            isSelected: true
        ) {}

        TemplateButton(
            template: Template.all[0],
            isSelected: false
        ) {}
    }
}
