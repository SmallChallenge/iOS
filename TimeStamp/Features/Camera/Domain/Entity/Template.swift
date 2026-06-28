//
//  Template.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI


/// 템플릿 스타일 (Domain Layer)
enum TemplateStyle: CaseIterable {
    case minimal
    case accent
    case fun
    case fixel
}


/// MARK: 템플릿
struct Template: Identifiable, Equatable {
    let style: TemplateStyle
    let templateId: String
    let name: String // asset이름 가져올 때 씀.
    private let viewBuilder: (Date, Bool) -> AnyView

    var id: String { templateId }

    init(style: TemplateStyle, templateId: String,  name: String, viewBuilder: @escaping (Date, Bool) -> AnyView) {
        self.name = name
        self.templateId = templateId
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
        
        // MARK: - Minimal (깔끔)
        Template(
            style: .minimal,
            templateId: "minimal_001",
            name: "Minimal001Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal001Template(displayDate: date, hasLogo: hasLogo))
            }
        ),
        
        Template(
            style: .minimal,
            templateId: "minimal_002",
            name: "Minimal002Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal002Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            templateId: "minimal_003",
            name: "Minimal003Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal003Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            templateId: "minimal_004",
            name: "Minimal004Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal004Template(displayDate: date, hasLogo: hasLogo))
            }),

        Template(
            style: .minimal,
            templateId: "minimal_005",
            name: "Minimal005Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal005Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            templateId: "minimal_006",
            name: "Minimal006Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal006Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            templateId: "minimal_007",
            name: "Minimal007Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal007Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            templateId: "minimal_008",
            name: "Minimal008Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal008Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            templateId: "minimal_009",
            name: "Minimal009Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal009Template(displayDate: date, hasLogo: hasLogo))
            }),
        


        // MARK:  - Accent (강조)
        Template(
            style: .accent,
            templateId: "accent_001",
            name: "Accent001Template",
            viewBuilder: { date, hasLog in
                AnyView(Accent001Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .accent,
            templateId: "accent_002",
            name: "Accent002Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent002Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            templateId: "accent_003",
            name: "Accent003Template",
            viewBuilder: { date, hasLog in
                AnyView(Accent003Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .accent,
            templateId: "accent_004",
            name: "Accent004Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent004Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            templateId: "accent_005",
            name: "Moody6Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent005Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            templateId: "accent_006",
            name: "Active2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent006Template(displayDate: date, hasLogo: hasLogo))
            }),

        Template(
            style: .accent,
            templateId: "accent_007",
            name: "Active5Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent007Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            templateId: "accent_008",
            name: "Active8Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent008Template(displayDate: date, hasLogo: hasLogo))
            }),

        // MARK:  - Fun (재미)
        
        Template(
            style: .fun,
            templateId: "fun_001",
            name: "Digital4Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun001Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .fun,
            templateId: "fun_002",
            name: "Moody4Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun002Template(displayDate: date, hasLogo: hasLogo))
            }),

        Template(
            style: .fun,
            templateId: "fun_003",
            name: "Active6Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun003Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        
        Template(
            style: .fun,
            templateId: "fun_004",
            name: "Active7Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun004Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .fun,
            templateId: "fun_005",
            name: "Moody2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun005Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .fun,
            templateId: "fun_006",
            name: "Moody3Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun006Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .fun,
            templateId: "fun_007",
            name: "Digital1Template",
            viewBuilder: { date, hasLog in
                AnyView(Fun007Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .fun,
            templateId: "fun_008",
            name: "Moody5Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun008Template(displayDate: date, hasLogo: hasLogo))
            }),
    
       
        
        Template(
            style: .fun,
            templateId: "fun_009",
            name: "Moody8Template",
            viewBuilder: { date, hasLogo in
                AnyView(Fun009Template(displayDate: date, hasLogo: hasLogo))
            }),

       
        // MARK: - Fixel
     
        
        Template(
            style: .fixel,
            templateId: "fixel_001",
            name: "Digital2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital2Template(displayDate: date, hasLogo: hasLogo))
            }),

        
        Template(
            style: .fixel,
            templateId: "fixel_002",
            name: "Digital3Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital3Template(displayDate: date, hasLogo: hasLogo))
            }),
      
        Template(
            style: .fixel,
            templateId: "fixel_003",
            name: "Digital5Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital5Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .fixel,
            templateId: "fixel_004",
            name: "Digital6Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital6Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .fixel,
            templateId: "fixel_005",
            name: "Digital7Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital7Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .fixel,
            templateId: "fixel_006",
            name: "Digital8Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital8Template(displayDate: date, hasLogo: hasLogo))
            }),
    ]
}
