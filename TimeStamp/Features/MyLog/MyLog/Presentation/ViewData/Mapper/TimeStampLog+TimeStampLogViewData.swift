//
//  TimeStampLog+TimeStampLogViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 12/26/25.
//

import Foundation

extension TimeStampLog {
    func toViewData() -> TimeStampLogViewData {
        let category = CategoryViewDataMapper().toViewData(from: self.category)
        return TimeStampLogViewData(
            id: self.id,
            category: category,
            timeStamp: self.timeStamp,
            imageSource: self.imageSource,
            visibility: self.visibility
        )
    }
}
