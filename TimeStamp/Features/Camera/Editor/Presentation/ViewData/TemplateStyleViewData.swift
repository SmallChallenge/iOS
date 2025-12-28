//
//  TemplateStyleViewData.swift
//  TimeStamp
//
//  Created by Claude on 12/28/25.
//

import Foundation

/// 템플릿 스타일 ViewData (Presentation Layer)
enum TemplateStyleViewData: CaseIterable {
    case basic
    case moody
    case active
    case digital

    var name: String {
        switch self {
        case .basic: return "Basic"
        case .moody: return "Moody"
        case .active: return "Active"
        case .digital: return "Digital"
        }
    }


    /// ViewData와 Domain 직접 비교
    static func == (lhs: TemplateStyleViewData, rhs: TemplateStyle) -> Bool {
        switch (lhs, rhs) {
        case (.basic, .basic): return true
        case (.moody, .moody): return true
        case (.active, .active): return true
        case (.digital, .digital): return true
        default: return false
        }
    }

    static func == (lhs: TemplateStyle, rhs: TemplateStyleViewData) -> Bool {
        (rhs == lhs)
    }
}
