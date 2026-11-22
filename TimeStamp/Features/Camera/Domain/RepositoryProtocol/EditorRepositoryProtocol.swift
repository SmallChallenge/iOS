//
//  EditorRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 5/13/26.
//


protocol EditorRepositoryProtocol {
    /// 선택한 템플릿id 저장
    func saveSelectedTemplateId(templateId: String)
    
    /// 이전에 선택한 템플릿id 가져오기
    func getLastSelectedTemplateId() -> String?
    
    
    /// 템플릿 즐겨찾기 ids 저장
    func saveFavoriteTemplateIds(_ templateIds: [String])
    
    /// 템플릿 즐겨찾기 ids 불러오기
    func getFavoriteTemplateIds() -> [String]
}

