//
//  Pretendard.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - Font Protocol

/// 모든 폰트가 구현해야 하는 프로토콜
protocol FontWeightProtocol {
    var fontName: String { get }
}

// MARK: - Font Family

/// 여러 폰트 패밀리를 관리하는 enum
enum AppFont {
    case pretendard(Pretendard)
    case moveSans(MoveSans)
    
    /// 기후위기
    case climateCrisis
    
    case suit(Suit)
    
    case partialSans
    // 다른 폰트 추가 예시:
    // case roboto(Roboto)
    // case notoSans(NotoSans)
    
    case dungGeunMo(DungGeunMo)
    
    case ericaOne
    
    case shipporiMincho(ShipporiMincho)
    
    case bMKkubulim
    
    case ownglyph
    
    case cafe24PROUP
    
    case lineSeedKR(LINESeedKR)
    
    case monofett

    case keriskedu(KERISKEDU)
    
    case spaceMono(SpaceMono)
    
    case notable
    
    case montserrat(Montserrat)
    
    case rixInooAriDuri

    var fontName: String {
        switch self {
        case .pretendard(let weight):
            return weight.fontName
        // case .roboto(let weight):
        //     return weight.fontName
            
        case .moveSans(let weight):
            return weight.fontName
            
        case .climateCrisis:
            return ClimateCrisis._1990.fontName
            
        case let .suit(weight):
            return weight.fontName
            
        case .partialSans:
            return PartialSans.regular.fontName
            
        case let .dungGeunMo(weight):
            return weight.fontName
            
        case .ericaOne:
            return EricaOne.regular.fontName
            
        case let .shipporiMincho(weight):
            return weight.fontName
            
        case .bMKkubulim:
            return BMKkubulim.regular.fontName
            
        case .ownglyph:
            return Ownglyph.regular.fontName
            
        case .cafe24PROUP:
            return Cafe24PROUP.regular.fontName
            
        case let .lineSeedKR(weight):
            return weight.fontName
            
        case .monofett:
            return Monofett.regular.fontName
            
        case let .keriskedu(weight):
            return weight.fontName
            
        case let .spaceMono(weight):
            return weight.fontName
            
        case .notable:
            return Notable.regular.fontName
            
        case let .montserrat(weight):
            return weight.fontName
            
        case .rixInooAriDuri:
            return RixInooAriDuri.regular.fontName
            
        }
    }
}

// MARK: - Pretendard

enum Pretendard: String, FontWeightProtocol {
    case black = "Pretendard-Black"
    case bold = "Pretendard-Bold"
    case extraBold = "Pretendard-ExtraBold"
    case extraLight = "Pretendard-ExtraLight"
    case light = "Pretendard-Light"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
    case semiBold = "Pretendard-SemiBold"
    case thin = "Pretendard-Thin"

    var fontName: String {
        return rawValue
    }
}

// MARK: - MoveSans
enum MoveSans: String, FontWeightProtocol {
    
    case bold = "MoveSans-Bold"
    case medium = "MoveSans-Medium"
    case light = "MoveSans-Light"
    
    var fontName: String {
        return rawValue
    }
}

// MARK: - ClimateCrisis
enum ClimateCrisis: String, FontWeightProtocol {
    case _1990 = "ClimateCrisisKR-1990"
    
    var fontName: String {
        return rawValue
    }
}

// MARK: - SUIT
enum Suit: String, FontWeightProtocol {
    case bold = "SUIT-Bold"
    case extraBold = "SUIT-ExtraBold"
    case extraLight = "SUIT-ExtraLight"
    case heavy = "SUIT-Heavy"
    case light = "SUIT-Light"
    case medium = "SUIT-Medium"
    case regular = "SUIT-Regular"
    case semiBold = "SUIT-SemiBold"
    case thin = "SUIT-Thin"
    
    var fontName: String {
        return rawValue
    }
}

// MARK: - PartialSans 파샬산스
enum PartialSans: String, FontWeightProtocol {
    // PartialSansKR-Regular.otf
    case regular = "Partial-Sans-KR"
    var fontName: String {
        return rawValue
    }
}

// MARK: - DungGeunMo
enum DungGeunMo: String, FontWeightProtocol {
    case regular = "DungGeunMo"
    case bold = "BoldDunggeunmo"
    var fontName: String {
        return rawValue
    }
}

// MARK: - DungGeunMo
enum EricaOne: String, FontWeightProtocol {
    case regular = "EricaOne-Regular"
    var fontName: String {
        return rawValue
    }
}

// MARK: - ShipporiMincho
enum ShipporiMincho: String, FontWeightProtocol {
    case bold = "ShipporiMincho-Bold"
    case extraBold = "ShipporiMincho-ExtraBold"
    case medium = "ShipporiMincho-Medium"
    case regular = "ShipporiMincho-Regular"
    case semiBold = "ShipporiMincho-SemiBold"
    var fontName: String {
        return rawValue
    }
}

// MARK: - BMKkubulim
enum BMKkubulim: String, FontWeightProtocol {
    case regular = "BMkkubulim-Regular"
    var fontName: String {
        return rawValue
    }
}

// MARK: - Ownglyph
enum Ownglyph: String, FontWeightProtocol {
    case regular = "Ownglyph_PDH-Rg"
    var fontName: String {
        return rawValue
    }
}

// MARK: - Cafe24PROUP
enum Cafe24PROUP: String, FontWeightProtocol {
    case regular = "Cafe24PROUP"
    var fontName: String {
        return rawValue
    }
}

// MARK: - LINESeedKR
enum LINESeedKR: String, FontWeightProtocol {
    case regular = "LINESeedSansKR-Regular"
    case bold = "LINESeedSansKR-Bold"
    case thin = "LINESeedSansKR-Thin"
    var fontName: String {
        return rawValue
    }
}

// MARK: - Monofett
enum Monofett: String, FontWeightProtocol {
    case regular = "Monofett-Regular"
    var fontName: String {
        return rawValue
    }
}

// MARK: - KERISKEDU
enum KERISKEDU: String, FontWeightProtocol {
    case regular = "KERISKEDUOTF_R"
    case line = "KERISKEDUOTF_Line"
    case bold = "KERISKEDUOTF_B"
    var fontName: String {
        return rawValue
    }
}

// MARK: - SpaceMono
enum SpaceMono: String, FontWeightProtocol {
    case regular = "SpaceMono-Regular"
    case bold = "SpaceMono-Bold"
    case boldItalic = "SpaceMono-BoldItalic"
    case italic = "SpaceMono-Italic"
    
    var fontName: String {
        return rawValue
    }
}

// MARK: - Notable
enum Notable: String, FontWeightProtocol {
    case regular = "Notable-Regular"
    var fontName: String {
        return rawValue
    }
}

// MARK: - Montserrat
enum Montserrat: String, FontWeightProtocol {
    case regular = "Montserrat-Regular"
    case black = "Montserrat-Black"
    case bold = "Montserrat-Bold"
    case extraBold = "Montserrat-ExtraBold"
    case extraLight = "Montserrat-ExtraLight"
    case light = "Montserrat-Light"
    case medium = "Montserrat-Medium"
    case semiBold = "Montserrat-SemiBold"
    case thin = "Montserrat-Thin"
    var fontName: String {
        return rawValue
    }
}

// MARK: - RixInooAriDuri
enum RixInooAriDuri: String, FontWeightProtocol {
    case regular = "RixInooAriDuriPR"
    var fontName: String {
        return rawValue
    }
}



// MARK: - 다른 폰트 추가 예시
/*
enum Roboto: String, FontWeightProtocol {
    case black = "Roboto-Black"
    case bold = "Roboto-Bold"
    case medium = "Roboto-Medium"
    case regular = "Roboto-Regular"
    case light = "Roboto-Light"
    case thin = "Roboto-Thin"

    var fontName: String {
        return rawValue
    }
}

enum NotoSans: String, FontWeightProtocol {
    case black = "NotoSansKR-Black"
    case bold = "NotoSansKR-Bold"
    case medium = "NotoSansKR-Medium"
    case regular = "NotoSansKR-Regular"
    case light = "NotoSansKR-Light"

    var fontName: String {
        return rawValue
    }
}
*/

// MARK: - SwiftUI Modifier

struct CustomFontModifier: ViewModifier {
    private var fontSize: CGFloat
    private var fontName: String
    private var trackingPercent: CGFloat?

    init(_ font: AppFont, size: CGFloat, trackingPercent: CGFloat? = nil) {
        self.fontSize = size
        self.fontName = font.fontName
        self.trackingPercent = trackingPercent
    }

//    /55pt 텍스트: .tracking(-1.1) (55 × -2% = -1.1)/
    func body(content: Content) -> some View {
        let baseContent = content.font(.custom(fontName, size: fontSize))

        if let trackingPercent = trackingPercent {
            baseContent.tracking(fontSize * trackingPercent)
        } else {
            baseContent
        }
    }
}

// MARK: - SwiftUI Extension

extension View {
    /// AppFont를 사용하여 폰트 적용
    /// - Parameters:
    ///   - font: 적용할 폰트 (.pretendard(.bold) 형식)
    ///   - size: 폰트 크기
    func font(_ font: AppFont, size: CGFloat, trackingPercent: CGFloat? = nil) -> some View {
        self.modifier(CustomFontModifier(font, size: size, trackingPercent: trackingPercent))
    }
}

// MARK: - UIKit Helper

extension AppFont {
    /// UIFont 반환
    func uiFont(size: CGFloat) -> UIFont {
        return UIFont(name: fontName, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
