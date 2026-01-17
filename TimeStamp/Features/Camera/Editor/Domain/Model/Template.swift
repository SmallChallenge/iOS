//
//  Template.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI


/// 템플릿 스타일 (Domain Layer)
enum TemplateStyle: CaseIterable {
    case basic
    case moody
    case active
    case digital
}


/// MARK: 템플릿
struct Template: Identifiable, Equatable {
    let style: TemplateStyle
    let name: String
    private let viewBuilder: (Date, Bool) -> AnyView

    var id: String { name }

    init(style: TemplateStyle, name: String, viewBuilder: @escaping (Date, Bool) -> AnyView) {
        self.name = name
        self.style = style
        self.viewBuilder = viewBuilder
    }

    /// 템플릿 뷰 생성
    @ViewBuilder
    func makeView(displayDate: Date, hasLogo: Bool) -> some View {
        viewBuilder(displayDate, hasLogo)
    }

    static func == (lhs: Template, rhs: Template) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - 템플릿 목록

extension Template {
    /// 모든 템플릿
    static let all: [Template] = [
        // MARK: - Basic
        Template(
            style: .basic,
            name: "Basic1Template",
            viewBuilder: { date, hasLogo in
                AnyView(Basic1Template(displayDate: date, hasLogo: hasLogo))
            }
        ),
        
        Template(
            style: .basic,
            name: "Basic2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Basic2Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .basic,
            name: "Basic3Template",
            viewBuilder: { date, hasLogo in
                AnyView(Basic3Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .basic,
            name: "Basic4Template",
            viewBuilder: { date, hasLogo in
                AnyView(Basic4Template(displayDate: date, hasLogo: hasLogo))
            }),


        // MARK:  - Moody
        Template(
            style: .moody,
            name: "Moody1Template",
            viewBuilder: { date, hasLog in
                AnyView(Moody1Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .moody,
            name: "Moody2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Moody2Template(displayDate: date, hasLogo: hasLogo))
            }),

        
        Template(
            style: .moody,
            name: "Moody3Template",
            viewBuilder: { date, hasLogo in
                AnyView(Moody3Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .moody,
            name: "Moody4Template",
            viewBuilder: { date, hasLogo in
                AnyView(Moody4Template(displayDate: date, hasLogo: hasLogo))
            }),

        // MARK: - Active
        Template(
            style: .active,
            name: "Active1Template",
            viewBuilder: { date, hasLog in
                AnyView(Active1Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .active,
            name: "Active2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Active2Template(displayDate: date, hasLogo: hasLogo))
            }),

        
        Template(
            style: .active,
            name: "Active3Template",
            viewBuilder: { date, hasLogo in
                AnyView(Active3Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        
        Template(
            style: .active,
            name: "Active4Template",
            viewBuilder: { date, hasLogo in
                AnyView(Active4Template(displayDate: date, hasLogo: hasLogo))
            }),


        // MARK: - Digital
        Template(
            style: .digital,
            name: "Digital1Template",
            viewBuilder: { date, hasLog in
                AnyView(Digital1Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .digital,
            name: "Digital2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital2Template(displayDate: date, hasLogo: hasLogo))
            }),

        
        Template(
            style: .digital,
            name: "Digital3Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital3Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        
        Template(
            style: .digital,
            name: "Digital4Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital4Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        
    ]
}






