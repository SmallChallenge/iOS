//
//  APINetworkLogger.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//


import Foundation
import Alamofire

public final class APINetworkLogger: EventMonitor {
    public let queue = DispatchQueue(label: "api.network.logger")

    public init() {}

    // Event called when any type of Request is resumed.
    public func requestDidResume(_ request: Request) {
        #if DEBUG
        let bodyString = request.request.flatMap { req in
            req.httpBody.flatMap { String(data: $0, encoding: .utf8) }
        } ?? "No Body"
        Logger.network("➡️ [REQUEST] \(request)")
        Logger.network("   Headers: \(request.request?.allHTTPHeaderFields ?? [:])")
        Logger.network("   Body: \(bodyString)")
        #endif
    }

    // Event called whenever a DataRequest has parsed a response.
    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        #if DEBUG
        let status = response.response?.statusCode ?? -1
        var bodyString = ""
        if let data = response.data, let str = String(data: data, encoding: .utf8) {
            bodyString = str
        }
        // 상태 코드에 따라 이모지 구분
        let emoji = (200..<300).contains(status) ? "✅" : "❌"
        Logger.network("\(emoji) [RESPONSE] status: \(status) for: \(request)")
        Logger.network("   Body: \(bodyString)")
        #endif
    }
}
