//
//  Router.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation
import Alamofire

public protocol Router {
    var baseURL: URL { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var encoding: Encoding? { get }
}

extension Router {
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.method = method

        // 헤더 추가
        if let headers = headers {
            headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.name) }
        }

        // 파라미터 인코딩 방식, 선택한 인코딩방식이 없는 경우 httpMethod에 따라 인코딩
        let encoding: Encoding = if let encoding { encoding }
        else if [.post, .put, .patch].contains(method) { .json }
        else { .url }

        switch encoding {
        case .json:
            request = try JSONEncoding.default.encode(request, with: parameters)
        case .url:
            request = try URLEncoding.default.encode(request, with: parameters)
        }
        return request
    }
}

// MARK: - Encoding

public enum Encoding {
    case json
    case url
}
