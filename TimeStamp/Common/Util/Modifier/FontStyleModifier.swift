//
//  FontExtension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation
import UIKit
import SwiftUI


public enum FontStyle {
    case H1
    case H2
    case H3
    case Body1
    case Body2
    case SubTitle1
    case SubTitle2
    case Btn1_b
    case Btn1
    case Btn2_b
    case Btn2
    case Caption
    case Label
    
    var name: String {
        switch self {
            
        case .H1:
            "Pretendard-SemiBold"
        case .H2:
            "Pretendard-SemiBold"
        case .H3:
            "Pretendard-SemiBold"
        case .Body1:
            "Pretendard-Regular"
        case .Body2:
            "Pretendard-Regular"
        case .SubTitle1:
            "Pretendard-SemiBold"
        case .SubTitle2:
            "Pretendard-SemiBold"
        case .Btn1_b:
            "Pretendard-SemiBold"
        case .Btn1:
            "Pretendard-Medium"
        case .Btn2_b:
            "Pretendard-SemiBold"
        case .Btn2:
            "Pretendard-Medium"
        case .Caption:
            "Pretendard-Regular"
        case .Label:
            "Pretendard-Medium"
        }
    }
    
    var size: CGFloat {
        switch self {
        case .H1: return 40
        case .H2: return 24
        case .H3: return 20
            
        case .Body1: return 16
        case .Body2: return 14
            
        case .SubTitle1: return 16
        case .SubTitle2: return 14
            
        case .Btn1_b: return 16
        case .Btn1: return 16
        case .Btn2_b: return 14
        case .Btn2: return 14

        case .Caption: return 12
        case .Label: return 10
        }
    }
    
    /*
    var weight: UIFont.Weight {
        switch self {
        case .H1: return .semibold
        case .H2: return .semibold
        case .H3: return .semibold
            
        case .Body1: return  .regular
        case .Body2: return  .regular
            
        case .SubTitle1: return  .semibold
        case .SubTitle2: return  .semibold
            
        case .Btn1_b: return  .semibold
        case .Btn1: return  .medium
        case .Btn2_b: return  .semibold
        case .Btn2: return  .medium
            
        case .Caption: return  .regular
        case .Label: return  .medium
        }
    }*/
    
   
}

public struct FontStyleModifier: ViewModifier {
    private var fontSize: CGFloat
    private var fontName: String
    
    public init(style fontStyle: FontStyle) {
        self.fontSize = fontStyle.size
        self.fontName = fontStyle.name
    }
    
    public func body(content: Content) -> some View {
        content
            .font(.custom(fontName, size: fontSize))
    }
}


public extension Text {
    func font(_ fontStyle: FontStyle) -> ModifiedContent<Text, FontStyleModifier> {
        modifier(FontStyleModifier(style: fontStyle))
    }
}
public extension TextField {
    func font(_ fontStyle: FontStyle) -> ModifiedContent<TextField, FontStyleModifier> {
        modifier(FontStyleModifier(style: fontStyle))
    }
}


/*
extension UIFont {
    static func pretendard(size fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        var fontName: String
        switch weight {
        case .black:
            fontName = "Pretendard-Black"
        case .bold:
            fontName = "Pretendard-Bold"
            
        case .heavy:
            fontName = "Pretendard-ExtraBold"
            
        case .ultraLight:
            fontName = "Pretendard-ExtraLight"
            
        case .light:
            fontName = "Pretendard-Light"
            
        case .medium:
            fontName = "Pretendard-Medium"
            
        case .regular:
            fontName = "Pretendard-Regular"
            
        case .semibold:
            fontName = "Pretendard-SemiBold"
            
        case .thin:
            fontName = "Pretendard-Thin"
         
        default:
            fontName = "Pretendard-Regular"
        }
        
        return UIFont(name: fontName, size: fontSize) ?? .systemFont(ofSize: fontSize, weight: weight)
    }
}
*/
