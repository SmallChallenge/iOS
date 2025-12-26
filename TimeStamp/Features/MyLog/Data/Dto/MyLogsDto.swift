//
//  MyLogsDto.swift
//  TimeStamp
//
//  Created by 임주희 on 12/25/25.
//

import Foundation

struct MyLogsDto: Codable {
    let logs: [TimeStampLog]
    let pageInfo: PageInfo
    
    struct TimeStampLog: Codable {
        let imageId: Int
        let category: String
        let visibility: String
        let accessURL: String
       
        /// 실제 촬영 시간 (내 기록 정렬용)
        let originalTakenAt: String

        enum CodingKeys: String, CodingKey {
            case imageId = "imageId"
            case category, visibility
            
            case accessURL = "accessUrl"
            case originalTakenAt
        }
    }

    struct PageInfo: Codable {
        let currentPage: Int
        let pageSize: Int
        let totalElements: Int
        let totalPages: Int
        let isFirst: Bool
        let isLast: Bool
        let hasNext: Bool
        let hasPrevious: Bool
        
        enum CodingKeys: String, CodingKey {
            case currentPage, pageSize, totalElements, totalPages
            case isFirst = "first"
            case isLast = "last"
            case hasNext, hasPrevious
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case logs = "images"
        case pageInfo
    }
}
