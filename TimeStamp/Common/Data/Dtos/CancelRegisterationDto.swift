//
//  CancelRegisterationDto.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//

import Foundation

public struct CancelRegisterationDto: Codable {
    let userId: Int
    let deletedAt: String
}
