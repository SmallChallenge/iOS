//
//  CategoriesDto.swift
//  TimeStamp
//
//  Created by 임주희 on 6/22/26.
//

import Foundation

struct CategoriesDto: Codable {
    let categories: [CategoryDto]
    
    struct CategoryDto: Codable {
        let code: String
        let name: String
        let order: Int
    }
}
