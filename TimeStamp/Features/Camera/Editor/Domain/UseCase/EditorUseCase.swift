//
//  EditorUseCase.swift
//  Stampic
//
//  Created by 임주희 on 1/8/26.
//

import Foundation
import UIKit


protocol EditorUseCaseProtocol {
    func execute(from: UIViewController) async throws -> Int
    func load() async throws
}

struct EditorUseCase: EditorUseCaseProtocol {
    let repository: AdRepositoryProtocol
    
    func execute(from: UIViewController) async throws -> Int {
        return try await repository.showRewardedAd(fromRootViewController: from)
    }
    
    func load() async throws {
        try await repository.loadRewardedAd()
    }
}
