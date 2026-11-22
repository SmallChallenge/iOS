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
    
    
    /// 템플릿 즐겨찾기 ids 불러오기
    func getFavoriteTemplateIds() -> [String]
    
    ///  템플릿 즐겨찾기 id 추가하기
    /// - Parameter id: 새로 추가하려는 템플릿 id
    /// - Returns: 새로 추가된 id가 포함된 즐겨찾기 목록 (템플릿아이디 목록)
    func addFavoriteTemplate(id: String) -> [String]
    
    
    /// 템플릿 즐겨찾기 id 삭제하기
    /// - Parameter id: 삭제하려는 템플릿 id
    /// - Returns: 해당 id가 삭제된 즐겨찾기 목록 (템플릿아이디 목록)
    func removeFavoriteTemplate(id: String) -> [String]
    
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
    
    // 최근선택 템플린 Id 저장하기
    func saveSelectedTemplateId(templateId: String){
        repository.saveSelectedTemplateId(templateId: templateId)
    }
    
   
    // 템플릿 즐겨찾기 ids 불러오기
    func getFavoriteTemplateIds() -> [String] {
        repository.getFavoriteTemplateIds()
    }
    
    ///  템플릿 즐겨찾기 id 추가하기
    /// - Parameter id: 새로 추가하려는 템플릿 id
    /// - Returns: 새로 추가된 id가 포함된 즐겨찾기 목록 (템플릿아이디 목록)
    func addFavoriteTemplate(id: String) -> [String] {
        var ids = repository.getFavoriteTemplateIds()
        
        guard !ids.contains(id) else { return ids }
        ids.append(id)
        repository.saveFavoriteTemplateIds(ids)
        return ids
    }
    
    
    /// 템플릿 즐겨찾기 id 삭제하기
    /// - Parameter id: 삭제하려는 템플릿 id
    /// - Returns: 해당 id가 삭제된 즐겨찾기 목록 (템플릿아이디 목록)
    func removeFavoriteTemplate(id: String) -> [String] {
        var ids = repository.getFavoriteTemplateIds()

        ids.removeAll { $0 == id }
        repository.saveFavoriteTemplateIds(ids)

        return ids
    }
}
