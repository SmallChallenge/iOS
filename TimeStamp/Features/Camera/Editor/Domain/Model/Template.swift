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


/// 템플릿
struct Template: Identifiable, Equatable {
    let id: String
    let name: String
    let style: TemplateStyle
    private let viewBuilder: (Date, Bool) -> AnyView

    init(id: String, name: String, style: TemplateStyle, viewBuilder: @escaping (Date, Bool) -> AnyView) {
        self.id = id
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
            id: "default",
            name: "베이직",
            style: .basic,
            viewBuilder: { date, hasLogo in
                AnyView(DefaultTemplateView(displayDate: date, hasLogo: hasLogo))
            }
        ),

        // MARK:  - Moody
        Template(
            id: "default2",
            name: "Moody",
            style: .moody,
            viewBuilder: { date, hasLogo in
                AnyView(DefaultTemplateView2(displayDate: date, hasLogo: hasLogo))
            }
        ),

        // MARK: - Active
        Template(
            id: "sample1",
            name: "Active1",
            style: .active,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView())
            }
        ),
        Template(
            id: "sample2",
            name: "Active2",
            style: .active,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView2())
            }
        ),
        Template(
            id: "sample3",
            name: "Active3",
            style: .active,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView3())
            }
        ),

        // MARK: - Digital
        Template(
            id: "sample4",
            name: "Digital4",
            style: .digital,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView4())
            }
        ),
        Template(
            id: "sample5",
            name: "심플Digital",
            style: .digital,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView5())
            }
        ),
        Template(
            id: "sample6",
            name: "Digital6",
            style: .digital,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView6())
            }
        )
    ]
}






