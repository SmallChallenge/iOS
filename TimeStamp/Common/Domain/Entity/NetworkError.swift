//
//  NetworkError.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation

public enum NetworkError: Error {
    case urlError
    case invalidResponse
    case failToDecode(String)
    case dataNil
    case serverError(Int)
    case requestFailed(String)
    case noInternet
    case cancelled
    
    public var description: String {
        switch self {
        case .urlError:
            "URL이 올바르지 않습니다."
        case .invalidResponse:
            "응답값이 유효하지 않습니다."
        case .failToDecode(let description):
            "디코딩 에러 \(description)"
        case .dataNil:
            "데이터가 없습니다."
        case .serverError(let statusCode):
            "서버 에러: \(statusCode)"
        case .requestFailed(let message):
            "서버 요청 실패:  \(message)"
            
        case .noInternet:
            "인터넷 연결이 없습니다."
        case .cancelled:
            "사용자가 요청을 취소하였습니다."
        }
    }
}
