//
//  LogPolicy.swift
//  TimeStamp
//
//  Created by 임주희 on 6/30/26.
//

import Foundation

enum LogPolicy {
    static let maxLogCount: Int = 20
    static let warningLogCount: Int = (maxLogCount - 2)
}
