//
//  ActiveAccount.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import Foundation

struct ActiveAccount {
    let userId: Int
    let userStatus: Status
    let completedAt: String
    
    enum Status: String {
        case pending = "PENDING"
        case active = "ACTIVE"
    }
}

extension ActiveAccountDto {
    func toEntity() -> ActiveAccount {
        let status: ActiveAccount.Status = (self.userStatus.lowercased()) == "active" ? .active : .pending
        return ActiveAccount(
            userId: self.userId,
            userStatus: status,
            completedAt: self.completedAt
        )
    }
}
