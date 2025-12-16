//
//  TimeStampLog.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation

struct TimeStampLog {
    /// id in local
    let id: UUID
    let category: Category
    let timeStamp: Date
    let caption: String?
    
    var imageSource: ImageSource
    
    /// 공개여부
    let visibility: VisibilityType
    
    
    enum ImageSource {
        case local(LocalTimeStampImage)
        case remote(RemoteTimeStampImage) 
    }
    
    enum VisibilityType: String {
        case publicVisible = "전체공개"
        case privateVisible = "비공개"
        
        var displayName: String {
            self.rawValue
        }
    }
}
struct LocalTimeStampImage {
    let assetIdentifier: String
}
struct RemoteTimeStampImage {
    /// id in server
    let id: Int
    let imageUrl: String
}
