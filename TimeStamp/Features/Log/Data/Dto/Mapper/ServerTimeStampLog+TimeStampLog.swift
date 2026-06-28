//
//  ServerTimeStampLog+TimeStampLog.swift
//  TimeStamp
//
//  Created by 임주희 on 12/25/25.
//

import Foundation

extension MyLogsDto.TimeStampLogDto {
    func toEntity() -> TimeStampLog {
        let category = Category(rawValue: self.category) ?? .etc
        let visibility = VisibilityType(rawValue: self.visibility) ?? .privateVisible
        
        let timeStamp = self.originalTakenAt.toDate(.iso8601) ?? self.originalTakenAt.toDate(.iso8601WithMicroseconds) ?? Date()
        return TimeStampLog(
            id: UUID(),
            category: category,
            timeStamp: timeStamp,
            imageSource: TimeStampLog.ImageSource.remote(TimeStampLog.RemoteTimeStampImage(
                id: self.imageId,
                imageUrl: self.accessURL
            )),
            visibility: visibility
        )
    }
}

extension MyLogsDto.PageInfo {
    /// DTO를 Entity로 변환
    func toEntity() -> Stampic.PageInfo {
        return Stampic.PageInfo(
            
            currentPage: currentPage,
            hasNext: hasNext,
        )
    }
}
