//
//  TimeStampLog+TimeStampLogViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation

extension TimeStampLog {
    func toViewData() -> TimeStampLogViewData {
        return TimeStampLogViewData(
            id: self.id,
            category: self.category,
            timeStamp: self.timeStamp,
            imageSource: self.imageSource,
            visibility: self.visibility
        )
    }
}
