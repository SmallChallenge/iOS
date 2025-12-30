//
//  TimeStampLogViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation

struct TimeStampLogViewData: Identifiable, Hashable {
    /// id in local
    let id: UUID
    let category: CategoryViewData
    let timeStamp: Date

    
    var imageSource: TimeStampLog.ImageSource
    
    /// 공개여부
    let visibility: VisibilityType
}
