//
//  Template.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI

protocol TemplateViewProtocol: View {}

/// 템플릿
struct Template: Identifiable, Equatable {
    let id: String
    let name: String
    let category: Category
    private let viewBuilder: (Date, Bool) -> AnyView

    init(id: String, name: String, category: Category, viewBuilder: @escaping (Date, Bool) -> AnyView) {
        self.id = id
        self.name = name
        self.category = category
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
    /// 모든 템플릿 목록
    static let all: [Template] = [
        
        // MARK: 공부
        Template(
            id: "default",
            name: "기본",
            category: .study,
            viewBuilder: { date, hasLogo in
                AnyView(DefaultTemplateView(displayDate: date, hasLogo: hasLogo))
            }
        ),
        
        // MARK: 운동
        
        Template(
            id: "default2",
            name: "기본2",
            category: .health,
            viewBuilder: { date, hasLogo in
                AnyView(DefaultTemplateView2(displayDate: date, hasLogo: hasLogo))
            }
        ),
        
        // MARK: 음식
        Template(
            id: "sample1",
            name: "샘플1",
            category: .food,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView())
            }
        ),
        Template(
            id: "sample2",
            name: "샘플2",
            category: .food,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView2())
            }
        ),
        Template(
            id: "sample3",
            name: "샘플3",
            category: .food,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView3())
            }
        ),
        
        // MARK: 기타
        
        Template(
            id: "sample4",
            name: "샘플4",
            category: .etc,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView4())
            }
        ),
        Template(
            id: "sample5",
            name: "샘플5",
            category: .etc,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView5())
            }
        ),
        Template(
            id: "sample6",
            name: "샘플6",
            category: .etc,
            viewBuilder: { _, _ in
                AnyView(sampleTemplateView6())
            }
        )
    ]
}

// MARK: - 기존 코드 호환성

/// 기존 TemplateType을 Template로 변경 (deprecated)
@available(*, deprecated, renamed: "Template", message: "Use Template instead")
typealias TemplateType = Template





