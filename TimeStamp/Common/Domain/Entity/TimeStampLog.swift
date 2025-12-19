//
//  TimeStampLog.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation

struct TimeStampLog: Identifiable {
    /// id in local
    let id: UUID
    let category: Category
    let timeStamp: Date
    
    let imageSource: ImageSource
    
    /// 공개여부
    let visibility: VisibilityType
    
    enum ImageSource {
        case local(LocalTimeStampImage)
        case remote(RemoteTimeStampImage) 
    }
    
    
    struct LocalTimeStampImage {
        let imageFileName: String
    }
    struct RemoteTimeStampImage {
        /// id in server
        let id: Int
        let imageUrl: String
    }
}

/// 공개여부
enum VisibilityType:  Codable{
    case publicVisible
    case privateVisible
}
