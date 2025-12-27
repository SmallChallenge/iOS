//
//  TemplateStyleViewData.swift
//  TimeStamp
//
//  Created by Claude on 12/28/25.
//

import Foundation

/// 템플릿 스타일 ViewData (Presentation Layer)
enum TemplateStyleViewData: CaseIterable {
    case modern
    case vintage
    case cute
    case simple

    var name: String {
        switch self {
        case .modern: return "모던"
        case .vintage: return "빈티지"
        case .cute: return "큐트"
        case .simple: return "심플"
        }
    }


    /// ViewData와 Domain 직접 비교
    static func == (lhs: TemplateStyleViewData, rhs: TemplateStyle) -> Bool {
        switch (lhs, rhs) {
        case (.modern, .modern): return true
        case (.vintage, .vintage): return true
        case (.cute, .cute): return true
        case (.simple, .simple): return true
        default: return false
        }
    }

    static func == (lhs: TemplateStyle, rhs: TemplateStyleViewData) -> Bool {
        (rhs == lhs)
    }
}
