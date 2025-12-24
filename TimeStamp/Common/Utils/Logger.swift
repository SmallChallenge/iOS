//
//  Logger.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

/// 개발 환경에서만 로그를 출력하는 유틸리티
enum Logger {

    /// Debug 빌드에서만 로그 출력
    static func debug(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("🔍 [\(fileName):\(line)] \(function) - \(output)")
        #endif
    }

    /// 성공 로그 (초록색 체크마크)
    static func success(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("✅ [\(fileName):\(line)] \(function) - \(output)")
        #endif
    }

    /// 에러 로그 (빨간색 X)
    static func error(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("❌ [\(fileName):\(line)] \(function) - \(output)")
        #endif
    }

    /// 경고 로그 (노란색 경고)
    static func warning(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("⚠️ [\(fileName):\(line)] \(function) - \(output)")
        #endif
    }

    /// 네트워크 로그
    static func network(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        print("🌐 [\(fileName):\(line)] \(function) - \(output)")
        #endif
    }
}
