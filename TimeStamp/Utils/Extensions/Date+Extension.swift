//
//  Date+Extension.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

extension Date {
    enum DateFormat: String {
            case iso8601 = "yyyy-MM-dd'T'HH:mm:ss"
            case iso8601WithMilliseconds = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            case iso8601UTC = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            case dateOnly = "yyyy-MM-dd"
            case timeOnly = "HH:mm:ss"
            case dateTime = "yyyy-MM-dd HH:mm:ss"
            case koreanDate = "yyyy년 MM월 dd일"
            case koreanDateTime = "yyyy년 MM월 dd일 HH:mm:ss"
        }
    
    /// Date를 지정된 형식의 문자열로 변환
    /// - Parameters:
    ///   - format: 날짜 형식 (예: "yyyy-MM-dd'T'HH:mm:ss")
    ///   - timeZone: 타임존 (기본값: 현재 타임존)
    ///   - locale: 로케일 (기본값: en_US_POSIX)
    /// - Returns: 형식화된 날짜 문자열
    /// - NOTE:요일이나 월 이름을 한국어로 표시할 때만 Locale(identifier: "ko_KR") 사용하기
    func toString(format: String,
                  timeZone: TimeZone = .current,
                  locale: Locale = Locale(identifier: "en_US_POSIX")) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale
        return formatter.string(from: self)
    }
    
    
    /// 프리셋 형식을 사용하여 Date를 문자열로 변환
    /// - Parameters:
    ///   - format: 미리 정의된 날짜 형식 (DateFormat enum)
    ///   - timeZone: 타임존 (기본값: 현재 타임존)
    ///   - locale: 로케일 (기본값: en_US_POSIX)
    /// - Returns: 형식화된 날짜 문자열
    /// - NOTE:요일이나 월 이름을 한국어로 표시할 때만 Locale(identifier: "ko_KR") 사용하기
    func toString(_ format: DateFormat,
                     timeZone: TimeZone = .current,
                     locale: Locale = Locale(identifier: "en_US_POSIX")) -> String {
           return toString(format: format.rawValue, timeZone: timeZone, locale: locale)
       }
}
