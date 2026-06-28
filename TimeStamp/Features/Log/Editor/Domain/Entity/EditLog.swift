//
//  EditLog.swift
//  TimeStamp
//
//  Created by 임주희 on 1/2/26.
//

import Foundation

/// EditLogResponse entity
struct EditLog {
    let imageId: Int
    let category: Category
    let visibility: VisibilityType
    let visibilityChanged: Bool
    let updatedAt: Date
    let publishedAt: Date
}
