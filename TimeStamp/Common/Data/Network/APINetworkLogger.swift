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
        print("➡️ [REQUEST] \(request)\nHeaders: \(request.request?.allHTTPHeaderFields ?? [:])")
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
        print("⬅️ [RESPONSE] status: \(status) for: \(request)\nBody: \(bodyString)")
        #endif
    }
}