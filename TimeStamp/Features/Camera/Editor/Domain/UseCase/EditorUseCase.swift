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
    
    func getLastSelectedTemplateId() -> String?
    func saveSelectedTemplateId(templateId: String)
}

struct EditorUseCase: EditorUseCaseProtocol {
    let repository: EditorRepositoryProtocol
    let adRepository: AdRepositoryProtocol
    
    
    // MARK: ad
    func execute(from: UIViewController) async throws -> Int {
        return try await adRepository.showRewardedAd(fromRootViewController: from)
    }
    
    func load() async throws {
        try await adRepository.loadRewardedAd()
    }
    
    // MARK: 이전에 선택한 템플릿 id 가져오기
    func getLastSelectedTemplateId() -> String? {
        repository.getLastSelectedTemplateId()
    }
    
    func saveSelectedTemplateId(templateId: String){
        repository.saveSelectedTemplateId(templateId: templateId)
    }
}
