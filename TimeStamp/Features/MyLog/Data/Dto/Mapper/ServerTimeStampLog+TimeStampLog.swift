//
//  ServerTimeStampLog+TimeStampLog.swift
//  TimeStamp
//
//  Created by 임주희 on 12/25/25.
//

import Foundation

extension MyLogsDto.TimeStampLog {
    func toEntity() -> TimeStampLog {
        let category = Category(rawValue: self.category) ?? .etc
        let visibility = VisibilityType(rawValue: self.visibility) ?? .privateVisible
        
        return TimeStampLog(
            id: UUID(),
            category: category,
            timeStamp: self.originalTakenAt.toDate(.iso8601) ?? Date(),
            imageSource: TimeStampLog.ImageSource.remote(TimeStampLog.RemoteTimeStampImage(
                id: self.imageId,
                imageUrl: self.accessURL
            )),
            visibility: visibility
        )
    }
}
