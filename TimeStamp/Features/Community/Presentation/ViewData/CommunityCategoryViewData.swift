//
//  CommunityCategoryViewData.swift
//  TimeStamp
//
//  Created by 임주희 on 6/22/26.
//


struct CommunityCategoryViewData {
    let code: String
    let name: String
    let order: Int
}
extension CommunityCategoryViewData: Identifiable {
    var id: String {
        code
    }
}
extension CommunityCategoryViewData {
    init(from entity: CommunityCategory) {
        self.code = entity.code
        self.name = entity.name
        self.order = entity.order
    }
}
