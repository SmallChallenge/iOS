//
//  VersionEntity.swift
//  TimeStamp
//
//  Created by 임주희 on 9/6/26.
//


struct VersionEntity {
    let updateType: UpdateType
    let latestVersion: String
    let storeUrl: String
    let message: String?

    enum UpdateType: String, Codable {
        case required = "REQUIRED" // 필수 업데이트
        case optional = "OPTIONAL" // 권장 업데이트
        case none = "NONE"
    }
}

