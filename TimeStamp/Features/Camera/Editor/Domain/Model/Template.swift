//
//  Template.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI


/// 템플릿 스타일 (Domain Layer)
enum TemplateStyle: CaseIterable {
    case modern
    case vintage
    case cute
    case simple
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
        // MARK: - Modern
        Template(
            id: "default",
            name: "모던",
            style: .modern,
            viewBuilder: { date, hasLogo in
                AnyView(DefaultTemplateView(displayDate: date, hasLogo: hasLogo))
            }
        ),

        // MARK:  - Cute
        Template(
            id: "default2",
            name: "큐트",
            style: .cute,
            viewBuilder: { date, hasLogo in
                AnyView(DefaultTemplateView2(displayDate: date, hasLogo: hasLogo))
            }
        ),

        // MARK: - Vintage
        Template(
            id: "sample1",
            name: "빈티지1",
            style: .vintage,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView())
            }
        ),
        Template(
            id: "sample2",
            name: "빈티지2",
            style: .vintage,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView2())
            }
        ),
        Template(
            id: "sample3",
            name: "빈티지3",
            style: .vintage,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView3())
            }
        ),

        // MARK: - Simple
        Template(
            id: "sample4",
            name: "샘플4",
            style: .simple,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView4())
            }
        ),
        Template(
            id: "sample5",
            name: "심플5",
            style: .simple,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView5())
            }
        ),
        Template(
            id: "sample6",
            name: "샘플6",
            style: .simple,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView6())
            }
        )
    ]
}






