//
//  ResponseBody.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation

public struct ResponseBody<T: Decodable>: Decodable {
    var success: Bool
    var code: String?
    var message: String?
    var data: T?
    var timestamp: String
}
