//
//  StringExtension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/13/25.
//

import Foundation

extension String {
    var trim: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    // MARK: - DATE
    

    /// 문자열을 지정된 형식의 Date로 변환
    /// - Parameters:
    ///   - format: 날짜 형식 (예: "yyyy-MM-dd'T'HH:mm:ss")
    ///   - timeZone: 타임존 (기본값: 현재 타임존)
    ///   - locale: 로케일 (기본값: .us)
    /// - Returns: 변환된 Date 객체 (실패시 nil)
    func toDate(format: String,
                timeZone: TimeZone = .current,
                locale: Date.LocaleType = .us) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale.locale
        return formatter.date(from: self)
    }
    
    /// 프리셋 형식을 사용한 Date 변환
    func toDate(_ format: Date.DateFormat,
                timeZone: TimeZone = .current,
                locale: Date.LocaleType = .us) -> Date? {
        return toDate(format: format.rawValue, timeZone: timeZone, locale: locale)
    }
}

extension String? {
    var isEmptyOrNil: Bool {
        if let string = self {
            return string.isEmpty
        }
        return true
    }
}
