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
    
 
    case digital

    var name: String {
        switch self {
        case .minimal: return "깔끔"
        case .accent:  return "강조"
        case .fun: return "재미"
        case .fixel: return "픽셀"
    
        case .digital: return "Digital"
        }
    }


    /// ViewData와 Domain 직접 비교
    static func == (lhs: TemplateStyleViewData, rhs: TemplateStyle) -> Bool {
        switch (lhs, rhs) {
        case (.minimal, .minimal): return true
        case (.accent, .accent): return true
        case (.fun, .fun): return true
            
            
        case (.digital, .digital): return true
        default: return false
        }
    }

    static func == (lhs: TemplateStyle, rhs: TemplateStyleViewData) -> Bool {
        (rhs == lhs)
    }
}
