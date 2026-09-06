//
//  VersionDto.swift
//  TimeStamp
//
//  Created by 임주희 on 9/6/26.
//


public struct VersionDto : Codable {
    let updateType: UpdateType
    let latestVersion: String
    let storeUrl: String
    let message: String
    
    enum UpdateType: String, Codable {
        case optional = "OPTIONAL"
        case none = "NONE"
        
    }
}
extension VersionDto {
    func toEntity() -> VersionEntity {
        .init(updateType: VersionEntity.UpdateType(rawValue: updateType.rawValue) ?? .none,
              latestVersion: latestVersion,
              storeUrl: storeUrl,
              message: message
        )
    }
}
