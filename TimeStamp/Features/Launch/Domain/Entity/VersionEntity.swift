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
        case optional = "OPTIONAL"
        case none = "NONE"
    }

    var updateRequired: Bool {
        updateType == .optional
    }
}

