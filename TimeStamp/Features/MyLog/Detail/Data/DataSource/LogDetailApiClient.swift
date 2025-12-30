//
//  LogDetailApiClient.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import Foundation
import Alamofire

enum LogDetailRouter {
    case deleteLog(logId: Int)
}
extension LogDetailRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .deleteLog:
                .delete
        }
    }
    
    var path: String {
        switch self {
        case let .deleteLog(logId):
            "/api/v1/images/\(logId)"
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        nil
    }
    
    var encoding: Encoding? {
        nil
    }
}

// MARK: - LogDetailApiClient
protocol LogDetailApiClientProtocol {
    func deleteLog(logId: Int) async -> Result<DeleteLogDto,NetworkError>
}
final class LogDetailApiClient: ApiClient<LogDetailRouter>, LogDetailApiClientProtocol {
    func deleteLog(logId: Int) async -> Result<DeleteLogDto,NetworkError> {
        await request(LogDetailRouter.deleteLog(logId: logId))
    }
}


