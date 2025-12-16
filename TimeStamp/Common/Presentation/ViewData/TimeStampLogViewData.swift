//
//  TimeStampLogViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation

struct TimeStampLogViewData {
    /// id in local
    let id: UUID
    let category: Category
    let timeStamp: Date
    let caption: String?
    
    var imageSource: TimeStampLog.ImageSource
    
    /// 공개여부
    let visibility: TimeStampLog.VisibilityType
}
