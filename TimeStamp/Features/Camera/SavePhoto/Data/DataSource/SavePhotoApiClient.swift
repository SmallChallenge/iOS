//
//  SavePhotoApiClient.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
import Alamofire

enum SavePhotoRouter {
    case presignedUrl(fileName: String, size: Int)
    case saveTimeStamp(fileName: String, size: Int, objectKey: String, category: String, visibility: String, originalTakenAt: String)
    
}
extension SavePhotoRouter: Router {
    var baseURL: URL {
        URL(string: NetworkConfig.baseURL)!
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .presignedUrl,.saveTimeStamp:
                .post
            
        }
    }
    
    var path: String {
        switch self {
        case .presignedUrl: "api/v1/images/presigned-url"
        case .saveTimeStamp: "api/v1/images/save"
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        nil
    }
    
    var parameters: Alamofire.Parameters? {
        switch self {
        case let .presignedUrl(fileName, size):
            let params: Parameters = [
                "filename" : fileName,
                "contentType" : "image/jpeg",
                "fileSize" : size,
            ]
            return params
        case let .saveTimeStamp(fileName, size, objectKey, category, visibility, originalTakenAt):
            let params: Parameters = [
                "originalFilename" : fileName,
                "contentType" : "image/jpeg",
                "fileSize" : size,
                "objectKey" : objectKey,
                "category" : category,
                "visibility" : visibility,
                "originalTakenAt" : originalTakenAt,
            ]
            return params
        }
    }
    
    var encoding: Encoding? {
        nil
    }
}

// MARK: - SavePhotoApiClient
protocol SavePhotoApiClientProtocol {
    func presignedUrl(fileName: String, size: Int) async -> Result<ResponseBody<PresignedURLDto>, NetworkError>
    
    func saveTimeStamp(fileName: String, size: Int, objectKey: String, category: String, visibility: String, originalTakenAt: String) async -> Result<ResponseBody<SaveTimeStampDto>, NetworkError>
}
class SavePhotoApiClient: ApiClient<SavePhotoRouter>,SavePhotoApiClientProtocol {
    
    func presignedUrl(fileName: String, size: Int) async -> Result<ResponseBody<PresignedURLDto>, NetworkError>{
        await request(SavePhotoRouter.presignedUrl(fileName: fileName, size: size))
    }
    
    func saveTimeStamp(fileName: String, size: Int, objectKey: String, category: String, visibility: String, originalTakenAt: String) async -> Result<ResponseBody<SaveTimeStampDto>, NetworkError> {
        await request(SavePhotoRouter.saveTimeStamp(fileName: fileName, size: size, objectKey: objectKey, category: category, visibility: visibility, originalTakenAt: originalTakenAt))
    }
}
