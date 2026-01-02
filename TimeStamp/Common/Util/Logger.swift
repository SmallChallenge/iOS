//
//  Logger.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

/// 개발 환경에서만 로그를 출력하는 유틸리티
enum Logger {

    /// 메모리에 쌓이는 로그 (앱 실행 중에만 유지)
    private static var logs: [String] = []
    private static let maxLogs = 1000 // 최대 로그 개수 제한

    /// Debug 빌드에서만 로그 출력
    static func debug(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        let logMessage = "🔍 [\(fileName):\(line)] \(function) - \(output)"
        print(logMessage)
        appendLog(logMessage)
        #endif
    }

    /// 성공 로그 (초록색 체크마크)
    static func success(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        let logMessage = "✅ [\(fileName):\(line)] \(function) - \(output)"
        print(logMessage)
        appendLog(logMessage)
        #endif
    }

    /// 에러 로그 (빨간색 X)
    static func error(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        let logMessage = "❌ [\(fileName):\(line)] \(function) - \(output)"
        print(logMessage)
        appendLog(logMessage)
        #endif
    }

    /// 경고 로그 (노란색 경고)
    static func warning(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        let logMessage = "⚠️ [\(fileName):\(line)] \(function) - \(output)"
        print(logMessage)
        appendLog(logMessage)
        #endif
    }

    /// 네트워크 로그
    static func network(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        //let logMessage = "🌐 [\(fileName):\(line)] \(function) - \(output)"
        let logMessage = "🌐 \(output)"
        print(logMessage)
        appendLog(logMessage)
        #endif
    }
    
    /// 일반 정보 로그
    static func info(_ items: Any..., separator: String = " ", file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        let output = items.map { "\($0)" }.joined(separator: separator)
        let logMessage = "ℹ️ [\(fileName):\(line)] \(function) - \(output)"
        print(logMessage)
        appendLog(logMessage)
        #endif
    }

    // MARK: - 로그 관리

    /// 로그를 메모리에 추가
    private static func appendLog(_ message: String) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
        let logEntry = "[\(timestamp)] \(message)"

        logs.append(logEntry)

        // 최대 개수 초과 시 오래된 로그 삭제
        if logs.count > maxLogs {
            logs.removeFirst(logs.count - maxLogs)
        }
    }

    /// 쌓인 로그를 txt 파일로 만들어서 임시 디렉토리에 저장
    static func exportLogsToFile() -> URL? {
        guard !logs.isEmpty else { return nil }

        let fileName = "TimeStamp_Logs_\(Date().timeIntervalSince1970).txt"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        let logContent = """
        TimeStamp App Logs
        Generated: \(Date())
        Total Logs: \(logs.count)
        ========================================

        \(logs.joined(separator: "\n"))
        """

        do {
            try logContent.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("❌ 로그 파일 생성 실패: \(error)")
            return nil
        }
    }

    /// 쌓인 로그 초기화
    static func clearLogs() {
        logs.removeAll()
    }

    /// 현재 쌓인 로그 개수
    static func getLogCount() -> Int {
        return logs.count
    }
}
