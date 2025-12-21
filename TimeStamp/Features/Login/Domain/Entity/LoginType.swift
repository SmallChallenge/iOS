//
//  LoginType.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation

enum LoginType: String {
    case  kakao, google, apple
    
    init?(socialType: String) {
            self.init(rawValue: socialType.lowercased())
        }
}
