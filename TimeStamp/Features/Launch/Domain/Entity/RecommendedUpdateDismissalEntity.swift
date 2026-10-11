//
//  RecommendedUpdateDismissalEntity.swift
//  TimeStamp
//
//  Created by 임주희 on 10/11/26.
//

import Foundation

struct RecommendedUpdateDismissalEntity {
    let appVersion: String
    let dismissedAt: Date
}

struct RecommendedUpdateDismissalEntityMapper {
    func toEntity(from dto: RecommendedUpdateDismissal?) -> RecommendedUpdateDismissalEntity? {
        guard let dto else { return nil }
        return RecommendedUpdateDismissalEntity(
            appVersion: dto.appVersion,
            dismissedAt: dto.dismissedAt
        )
    }
}
