//
//  CommunityApiClient.swift
//  Stampic
//
//  Created by 임주희 on 1/3/26.
//

import Foundation
import Alamofire

enum CommunityRouter {
    
    // 피드 목록 가져오기
    case feeds(category: String?, size: Int?, lastPublishedAt: String?, lastImageId: Int?, sort: String?)
    
    case report(imageId: Int)
    // 신고하기를 취소하기
    case cancelReport(imageId: Int)
    
    case like(imageId: Int)
    
}
extension CommunityRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .feeds: .get
        case .report: .post
        case .cancelReport: .delete
        case .like: .post
        }
    }
    
    var path: String {
        switch self {
        case .feeds:
            return "api/v1/community/feeds"
        case let .report(imageId):
            return "api/v1/community/\(imageId)/report"
        case let .cancelReport(imageId):
            return "api/v1/community/\(imageId)/report"
        case let .like(imageId):
            return "api/v1/community/\(imageId)/like"

        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case let .feeds(category, size, lastPublishedAt, lastImageId, sort):
            var params: Parameters = [:]
            if let category {
                params["category"] = category
            }
            if let size {
                params["size"] = size
            }
            if let lastPublishedAt {
                params["lastPublishedAt"] = lastPublishedAt
            }
            if let lastImageId {
                params["lastImageId"] = lastImageId
            }
            if let sort {
                params["sort"] = sort
            }
            return params
            
        case .report: return nil
        case .cancelReport: return nil
        case .like: return nil
            
        }
    }
    
    var encoding: Encoding? {
        nil
    }
    
    
}

// MARK:  CommunityApiClient
protocol CommunityApiClientProtocol {
    /// 커뮤니티 피트 조회
    /// - Parameters:
    ///   - category: 조회할 카테고리 (EXERCISE, STUDY, FOOD 등) 없을 시 전체 조회.
    ///   - size:  한 번에 가져올 데이터 개수 (기본값 20).
    ///   - lastPublishedAt: 직전 조회 결과의 publishedAt 값. (첫 페이지 조회 시 null)
    ///   - lastImageId:  직전 조회 결과의 imageId 값. (첫 페이지 조회 시 null)
    ///   - sort: (LATEST: 최신순, POPULAR: 좋아요순) (기본값 : LATEST)
    func feeds(category: String?, size: Int?, lastPublishedAt: String?, lastImageId: Int?, sort: String?) async -> Result<feedsDto, NetworkError>
    
    /// 신고하기
    func report(imageId: Int) async -> Result<reportDto, NetworkError>
    
    /// 신고를 취소하기
    func cancelReport(imageId: Int) async -> Result<CancelReportDto, NetworkError>
    
    /// 로그 좋아요
    func like(imageId: Int) async -> Result<likeDto, NetworkError>
    
}
final class CommunityApiClient: ApiClient<CommunityRouter>,CommunityApiClientProtocol {
    func feeds(category: String?, size: Int?, lastPublishedAt: String?, lastImageId: Int?, sort: String?) async -> Result<feedsDto, NetworkError> {
        
        await request(.feeds(category: category, size: size, lastPublishedAt: lastPublishedAt, lastImageId: lastImageId, sort: sort))
    }
    
    
    func cancelReport(imageId: Int) async -> Result<CancelReportDto, NetworkError> {
        await request(.cancelReport(imageId: imageId))
    }
    
    func report(imageId: Int) async -> Result<reportDto, NetworkError>{
        await request(.report(imageId: imageId))
    }
    
    func like(imageId: Int) async -> Result<likeDto, NetworkError> {
        await request(.like(imageId: imageId))
    }
}
