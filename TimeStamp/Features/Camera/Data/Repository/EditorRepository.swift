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
}
