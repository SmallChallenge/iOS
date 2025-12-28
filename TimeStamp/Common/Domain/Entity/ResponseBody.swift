//
//  ResponseBody.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation

public struct ResponseBody<T: Decodable>: Decodable {
    var isSuccess: Bool
    var code: String?
    var message: String?
    var data: T?
    var timestamp: String


    enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
        case code
        case message
        case data
        case timestamp
    }
}

// 에러 응답용 (data 없이 code, message만)
public struct ErrorResponseBody: Decodable {
    var isSuccess: Bool
    var code: String
    var message: String
    var timestamp: String

    enum CodingKeys: String, CodingKey {
        case isSuccess = "success"
        case code
        case message
        case timestamp
    }
}
