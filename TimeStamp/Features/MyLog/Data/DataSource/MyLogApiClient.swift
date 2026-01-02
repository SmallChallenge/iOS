//
//  MyLogApiClient.swift
//  TimeStamp
//
//  Created by 임주희 on 12/25/25.
//

import Foundation
import Alamofire


enum MyLogRouter {
    case list(category: String?, page: Int, size: Int)
    case detail(id: Int)
    case edit(id: Int, category: String, visibility: String)
    case deleteLog(logId: Int)
    
}
extension MyLogRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .list: return .get
        case .detail: return .get
        case .edit: return .put
        case .deleteLog: return .delete
        }
    }
    
    var path: String {
        switch self {
        case .list: 
            return "/api/v1/images"
        case let .detail(id):
            return "/api/v1/images/\(id)"
            
        case let .edit(id, _,_):
            return "/api/v1/images/\(id)"
            
        case let .deleteLog(logId):
            return "/api/v1/images/\(logId)"
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case let .list(category, page, size):
            var params: Parameters = [
                "page" : page,
                "size" : size,
            ]
            if let category {
                params["category"] = category
            }
            return params
            
        case .detail:
            return nil
            
        case let .edit(_, category, visibility):
            let params: Parameters = [
                "category" : category,
                "visibility" : visibility,
            ]
            return params
            
        case .deleteLog:
            return nil
        }
    }
    
    var encoding: Encoding? {
        nil
    }
}


// MARK: - ApiClient
protocol MyLogApiClientProtocol {

    func fetchMyLogList(category: String?, page: Int, size: Int) async -> Result<MyLogsDto, NetworkError>
    func fetchLogDetail(id: Int) async -> Result<TimeStampLogDetailDto, NetworkError>
    func editLog(id: Int, category: String, visibility: String) async -> Result<EditLogDto, NetworkError>
    func deleteLog(logId: Int) async -> Result<DeleteLogDto,NetworkError>

}
final class MyLogApiClient: ApiClient<MyLogRouter>,MyLogApiClientProtocol {
   
    
    func fetchMyLogList(category: String?, page: Int, size: Int) async -> Result<MyLogsDto, NetworkError> {
        await request(MyLogRouter.list(category: category, page: page, size: size))
    }
    
    func fetchLogDetail(id: Int) async -> Result<TimeStampLogDetailDto, NetworkError> {
        await request(MyLogRouter.detail(id: id))
        
    }
    
    func editLog(id: Int, category: String, visibility: String) async -> Result<EditLogDto, NetworkError> {
        await request(MyLogRouter.edit(id: id, category: category, visibility: visibility))
    }
    
    func deleteLog(logId: Int) async -> Result<DeleteLogDto,NetworkError> {
        await request(MyLogRouter.deleteLog(logId: logId))
    }
}
