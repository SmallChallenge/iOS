//
//  LocalTimeStampLogDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation

struct LocalTimeStampLogDto: Identifiable, Codable {
    let id: UUID
    let category: String
    let timeStamp: Date
    
    // 로컬 이미지 경로
    let imageFileName: String
    var visibility: String
}
