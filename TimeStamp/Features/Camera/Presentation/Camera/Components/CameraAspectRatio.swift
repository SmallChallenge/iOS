//
//  CameraAspectRatio.swift
//  TimeStamp
//
//  Created by 임주희 on 11/23/26.
//

/// 카메라 비율

import Foundation

enum CameraAspectRatio: String {
    case threeFour   // 3:4
    case square      // 1:1

    /// 가로 / 세로
    var value: CGFloat {
        switch self {
        case .threeFour: return 3.0 / 4.0
        case .square:    return 1.0
        }
    }

    var title: String {
        switch self {
        case .threeFour: return "3:4"
        case .square:    return "1:1"
        }
    }
    
    /// 토글하면 바뀔 반대 비율
       var toggled: CameraAspectRatio {
           switch self {
           case .threeFour: return .square
           case .square:    return .threeFour
           }
       }

    mutating func toggle() {
        self = (self == .threeFour) ? .square : .threeFour
    }
}
