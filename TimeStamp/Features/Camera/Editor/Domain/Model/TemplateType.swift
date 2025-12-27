//
//  TemplateType.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI

/// 템플릿 타입
enum TemplateType: String, CaseIterable, Identifiable {
    case defaultTemplate = "기본"
    case defaultTemplate2 = "기본2"

    var id: String { rawValue }

    /// 템플릿이 속한 카테고리 (도메인 모델)
    var category: Category {
        switch self {
            // MARK: 공부
        case .defaultTemplate:
            return .study
            
            // MARK: 운동
        case .defaultTemplate2:
            return .health
            
            // MARK: 음식
            // MARK: 기타
            
        }
    }

    /// 템플릿 뷰 생성
    @ViewBuilder
    func makeView(hasLogo: Bool) -> some View {
        switch self {
        case .defaultTemplate:
            DefaultTemplateView(hasLogo: hasLogo)
            
        case .defaultTemplate2:
            DefaultTemplateView2(hasLogo: hasLogo)
        }
    }
}
