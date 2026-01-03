//
//  MyPageMenu.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import SwiftUI


struct MyPageMenu: View {
    let title: String
    let type: MenuType
    let action: () -> Void
    enum MenuType {
        case chevron
        case chevronText(text: String)
        case text(text: String)
        case none
    }
    init(_ title: String, type: MenuType = .none, action: @escaping () -> Void) {
        self.title = title
        self.type = type
        self.action = action
    }
    
    var body: some View {
        
        
        Button {
            action()
        } label: {
            HStack{
                Text(title)
                    .font(.Btn2_b)
                    .foregroundStyle(Color.gray300)
                
                Spacer()
                
                switch type {
                    
                case .chevron:
                    
                    ChevronRight()
                        .foregroundStyle(Color.gray500)
                        .padding(.trailing, 12)
                    
                case let .chevronText(text):
                    HStack(spacing: 4){
                        Text(text)
                            .font(.Btn2_b)
                        ChevronRight()
                            
                            .padding(.trailing, 12)
                    }
                    .foregroundStyle(Color.gray500)
                   
                        
                    
                case let .text(text):
                    Text(text)
                        .font(.Body2)
                        .foregroundStyle(Color.gray500)
                        .padding(.trailing, 20)
                    
                case .none:
                    EmptyView()
                }
                
            }
            .padding(.leading, 20)
            .padding(.vertical, 19.5)
        }
    }
}


#Preview {
    VStack(spacing: 0){
        MyPageMenu("이용약관", type: .chevron){}
        MyPageMenu("앱 버전", type: .text(text: "1.0.0")){}
        MyPageMenu("로그아웃"){}
    }
        .background(Color.black)
}
