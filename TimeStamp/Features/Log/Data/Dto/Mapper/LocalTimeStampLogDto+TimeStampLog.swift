//
//  LocalTimeStampLogDto+TimeStampLog.swift
//  TimeStamp
//
//  Created by 임주희 on 12/25/25.
//

import Foundation


extension LocalTimeStampLogDto {
    func toEntity() -> TimeStampLog {
        
        let category = Category(rawValue: self.category) ?? .etc
        let visibility = VisibilityType(rawValue: self.visibility) ?? .privateVisible
        
        // ImageSource 생성 (로컬 이미지)
        let imageSource = TimeStampLog.ImageSource.local(
            TimeStampLog.LocalTimeStampImage(imageFileName: self.imageFileName)
        )
        
        return TimeStampLog(
            id: self.id,
            category: category,
            timeStamp: self.timeStamp.toDate(.iso8601) ?? Date(),
            imageSource: imageSource,
            visibility: visibility
        )
    }
}
