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
    case serverFailed(code: String, message: String) // 서버에서 보낸 에러 정보
    case requestFailed(String)
    case noInternet
    case cancelled

    case unauthorized // 401
    case forbidden // 403
    case notFound // 404
    case timeout // 408

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
        case .serverFailed(let code, let message):
            "\(message) (코드: \(code))"
        case .requestFailed(let message):
            "서버 요청 실패: \(message)"
        case .noInternet:
            "인터넷 연결이 없습니다."
        case .cancelled:
            "사용자가 요청을 취소하였습니다."
        case .unauthorized:
            "인증이 필요합니다."
        case .forbidden:
            "접근 권한이 없습니다."
        case .notFound:
            "요청한 리소스를 찾을 수 없습니다."
        case .timeout:
            "요청 시간이 초과되었습니다."
        }
    }

    // 사용자에게 보여줄지 여부
    public var isUserFacing: Bool {
        switch self {
        case .noInternet, .serverError, .serverFailed, .timeout, .unauthorized, .forbidden, .notFound:
            return true
        default:
            return false
        }
    }
}
