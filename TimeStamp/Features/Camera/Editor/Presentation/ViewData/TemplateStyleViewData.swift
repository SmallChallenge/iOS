//
//  TemplateStyleViewData.swift
//  TimeStamp
//
//  Created by Claude on 12/28/25.
//

import Foundation

/// 템플릿 스타일 ViewData (Presentation Layer)
enum TemplateStyleViewData: CaseIterable {
    case minimal
    case accent
    case fun
    case fixel

    var name: String {
        switch self {
        case .minimal: return "깔끔"
        case .accent:  return "강조"
        case .fun: return "재미"
        case .fixel: return "픽셀"
        }
    }
    
    var enName: String {
        switch self {
        case .minimal: return "minimal"
        case .accent:  return "accent"
        case .fun: return "fun"
        case .fixel: return "fixel"

        }
    }

    /// ViewData와 Domain 직접 비교
    static func == (lhs: TemplateStyleViewData, rhs: TemplateStyle) -> Bool {
        switch (lhs, rhs) {
        case (.minimal, .minimal): return true
        case (.accent, .accent): return true
        case (.fun, .fun): return true
        case (.fixel, .fixel): return true
        default: return false
        }
    }

    static func == (lhs: TemplateStyle, rhs: TemplateStyleViewData) -> Bool {
        (rhs == lhs)
    }
}
