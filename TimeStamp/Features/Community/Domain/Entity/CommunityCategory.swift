//
//  CommunityCategory.swift
//  TimeStamp
//
//  Created by 임주희 on 6/22/26.
//


struct CommunityCategory {
    let code: String
    let name: String
    let order: Int
}
extension CommunityCategory {
    init(from dto: CategoriesDto.CategoryDto) {
        self.code = dto.code
        self.name = dto.name
        self.order = dto.order
    }
}