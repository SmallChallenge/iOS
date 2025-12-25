//
//  MyLogApiClient.swift
//  TimeStamp
//
//  Created by 임주희 on 12/25/25.
//

import Foundation
import Alamofire


enum MyLogRouter {
    case myLogList(category: String?, page: Int, size: Int)
    
}
extension MyLogRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .myLogList:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .myLogList:
                "/api/v1/images"
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case let .myLogList(category, page, size):
            var params: Parameters = [
                "page" : page,
                "size" : size,
            ]
            if let category {
                params["category"] = category
            }
            return params
        }
    }
    
    var encoding: Encoding? {
        nil
    }
    
    
}


// MARK: - ApiClient
protocol MyLogApiClientProtocol {
    
    func fetchMyLogList(category: String?, page: Int, size: Int) async -> Result<ResponseBody<MyLogsDto>, NetworkError>
    
}
final class MyLogApiClient: ApiClient<MyLogRouter>,MyLogApiClientProtocol {
    func fetchMyLogList(category: String?, page: Int, size: Int) async -> Result<ResponseBody<MyLogsDto>, NetworkError> {
        await request(MyLogRouter.myLogList(category: category, page: page, size: size))
    }
}


