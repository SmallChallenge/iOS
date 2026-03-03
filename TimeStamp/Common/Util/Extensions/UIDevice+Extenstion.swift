//
//  UIDevice+Extenstion.swift
//  Stampic
//
//  Created by 임주희 on 3/3/26.
//

import Foundation
import UIKit

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
            // 주요 모델 예시 (필요에 따라 추가 가능)
            case "iPhone14,2": return "iPhone 13 Pro"
            case "iPhone14,3": return "iPhone 13 Pro Max"
            case "iPhone14,4": return "iPhone 13 mini"
            case "iPhone14,5": return "iPhone 13"
            case "iPhone15,2": return "iPhone 14 Pro"
            case "iPhone15,3": return "iPhone 14 Pro Max"
            case "iPhone16,1": return "iPhone 15 Pro"
            case "iPhone16,2": return "iPhone 15 Pro Max"
            case "i386", "x86_64", "arm64": return "Simulator"
            default: return identifier
        }
    }
}
