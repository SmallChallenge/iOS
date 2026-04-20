//
//  Template.swift
//  TimeStamp
//
//  Created by 임주희 on 12/27/25.
//

import SwiftUI


/// 템플릿 스타일 (Domain Layer)
enum TemplateStyle: CaseIterable {
    case moody
    case active
    case digital
    
    case minimal
    case accent
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
            style: .minimal,
            name: "Minimal001Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal001Template(displayDate: date, hasLogo: hasLogo))
            }
        ),
        
        Template(
            style: .minimal,
            name: "Minimal002Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal002Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            name: "Minimal003Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal003Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            name: "Minimal004Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal004Template(displayDate: date, hasLogo: hasLogo))
            }),

        Template(
            style: .minimal,
            name: "Minimal005Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal005Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            name: "Minimal006Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal006Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            name: "Minimal007Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal007Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            name: "Minimal008Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal008Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .minimal,
            name: "Minimal009Template",
            viewBuilder: { date, hasLogo in
                AnyView(Minimal009Template(displayDate: date, hasLogo: hasLogo))
            }),
        


        // MARK:  - Accent
        Template(
            style: .accent,
            name: "Accent001Template",
            viewBuilder: { date, hasLog in
                AnyView(Accent001Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .accent,
            name: "Accent002Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent002Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            name: "Accent003Template",
            viewBuilder: { date, hasLog in
                AnyView(Accent003Template(displayDate: date, hasLogo: hasLog))
            }
        ),
        
        Template(
            style: .accent,
            name: "Accent004Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent004Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            name: "Moody6Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent005Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            name: "Active2Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent006Template(displayDate: date, hasLogo: hasLogo))
            }),

        Template(
            style: .accent,
            name: "Active5Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent007Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .accent,
            name: "Active8Template",
            viewBuilder: { date, hasLogo in
                AnyView(Accent008Template(displayDate: date, hasLogo: hasLogo))
            }),

        
        

        
        // MARK:  - Moody
        
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

        Template(
            style: .moody,
            name: "Moody5Template",
            viewBuilder: { date, hasLogo in
                AnyView(Moody5Template(displayDate: date, hasLogo: hasLogo))
            }),
    
       
        
        Template(
            style: .moody,
            name: "Moody8Template",
            viewBuilder: { date, hasLogo in
                AnyView(Moody8Template(displayDate: date, hasLogo: hasLogo))
            }),

        
        // MARK: - Active
       
     
        
       
        
      
        
      
        
        Template(
            style: .active,
            name: "Active6Template",
            viewBuilder: { date, hasLogo in
                AnyView(Active6Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .active,
            name: "Active7Template",
            viewBuilder: { date, hasLogo in
                AnyView(Active7Template(displayDate: date, hasLogo: hasLogo))
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
        
        Template(
            style: .digital,
            name: "Digital5Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital5Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .digital,
            name: "Digital6Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital6Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .digital,
            name: "Digital7Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital7Template(displayDate: date, hasLogo: hasLogo))
            }),
        
        Template(
            style: .digital,
            name: "Digital8Template",
            viewBuilder: { date, hasLogo in
                AnyView(Digital8Template(displayDate: date, hasLogo: hasLogo))
            }),
    ]
}






