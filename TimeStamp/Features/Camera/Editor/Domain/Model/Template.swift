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
    let id: String
    let style: TemplateStyle
    let name: String
    let thumbnailName: String
    private let viewBuilder: (Date, Bool) -> AnyView

    init(id: String, style: TemplateStyle, name: String, thumbnailName: String,viewBuilder: @escaping (Date, Bool) -> AnyView) {
        self.id = id
        self.name = name
        self.style = style
        self.thumbnailName = thumbnailName
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
            id: "Basic1Template",
            style: .basic,
            name: "Basic1Template",
            thumbnailName: "Basic1Template",
            viewBuilder: { date, hasLogo in
                AnyView(Basic1Template(displayDate: date, hasLogo: hasLogo))
            }
        ),
        

        // MARK:  - Moody
        Template(
            id: "Moody1Template",
            style: .moody,
            name: "Moody1Template",
            thumbnailName: "Moody1Template",
            viewBuilder: { date, hasLog in
                AnyView(Moody1Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        

        // MARK: - Active
        Template(
            id: "Active1Template",
            style: .active,
            name: "Active1Template",
            thumbnailName: "Active1Template",
            viewBuilder: { date, hasLog in
                AnyView(Active1Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        

        // MARK: - Digital
        Template(
            id: "Digital1Template",
            style: .digital,
            name: "Digital1Template",
            thumbnailName: "Digital1Template",
            viewBuilder: { date, hasLog in
                AnyView(Digital1Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
    ]
}






