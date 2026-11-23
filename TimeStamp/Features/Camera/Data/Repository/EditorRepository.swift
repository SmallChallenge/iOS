//
//  EditorRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 5/13/26.
//

import Foundation

struct EditorRepository: EditorRepositoryProtocol {
    
    // 선택한 템플릿id 저장
    func saveSelectedTemplateId(templateId: String){
        UserSettings.shared.lastSelectedTemplateId = templateId
    }
    
    // 이전에 선택한 템플릿id 가져오기
    func getLastSelectedTemplateId() -> String? {
        UserSettings.shared.lastSelectedTemplateId
    }
    
    // 템플릿 즐겨찾기 id 저장
    func saveFavoriteTemplateIds(_ templateIds: [String]){
        UserSettings.shared.favoriteTemplateIds = templateIds
    }
    
    // 템플릿 즐겨찾기 ids 불러오기
    func getFavoriteTemplateIds() -> [String] {
        UserSettings.shared.favoriteTemplateIds
    }
}
