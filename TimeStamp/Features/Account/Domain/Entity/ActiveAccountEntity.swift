//
//  ActiveAccountEntity.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import Foundation

struct ActiveAccountEntity {
    let userId: Int
    let userStatus: Status
    let completedAt: String
    
    enum Status: String {
        case pending = "PENDING"
        case active = "ACTIVE"
    }
}

extension ActiveAccountDto {
    func toEntity() -> ActiveAccountEntity {
        let status: ActiveAccountEntity.Status = (self.userStatus.lowercased()) == "active" ? .active : .pending
        return ActiveAccountEntity(
            userId: self.userId,
            userStatus: status,
            completedAt: self.completedAt
        )
    }
}
