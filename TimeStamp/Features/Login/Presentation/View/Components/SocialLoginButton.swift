//
//  SocialLoginButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import SwiftUI

struct SocialLoginButton: View {
    let type: SocialLoginType
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack (spacing: 10){
                Image(type.icon)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(type.title)
                    .font(.Btn1_b)
                    .foregroundStyle(Color.gray900)
            }
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(type.backgroundColor)
            .rounded(radius: 16)
           
            
        }
    }
}


enum SocialLoginType {
    case apple
    case kakao
    case google
    
    var title: String {
        switch self {
            
        case .apple:
            "Apple로 계속하기"
        case .kakao:
            "카카오로 계속하기"
        case .google:
            "Google로 계속하기"
        }
    }
    
    var icon: String {
        switch self {
        case .apple:
            "icon_login_logo_apple"
        case .kakao:
            "icon_login_logo_kakao"
        case .google:
            "icon_login_logo_google"
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .apple:
            Color.gray50
        case .kakao:
            Color(hex: "FEE500")
        case .google:
            Color.gray50
        }
    }
}

