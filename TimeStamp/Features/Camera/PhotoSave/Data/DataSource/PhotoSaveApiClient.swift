//
//  PhotoSaveApiClient.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
import Alamofire

enum PhotoSaveRouter {
    case presignedUrl(fileName: String, size: Int)
    case saveTimeStamp(fileName: String, size: Int, objectKey: String, category: String, visibility: String, originalTakenAt: String)

}
extension PhotoSaveRouter: Router {
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

// MARK: - PhotoSaveApiClient
protocol PhotoSaveApiClientProtocol {
    func presignedUrl(fileName: String, size: Int) async -> Result<PresignedURLDto, NetworkError>

    func saveTimeStamp(fileName: String, size: Int, objectKey: String, category: String, visibility: String, originalTakenAt: String) async -> Result<SaveTimeStampDto, NetworkError>
}
final class PhotoSaveApiClient: ApiClient<PhotoSaveRouter>, PhotoSaveApiClientProtocol {

    func presignedUrl(fileName: String, size: Int) async -> Result<PresignedURLDto, NetworkError>{
        await request(PhotoSaveRouter.presignedUrl(fileName: fileName, size: size))
    }

    func saveTimeStamp(fileName: String, size: Int, objectKey: String, category: String, visibility: String, originalTakenAt: String) async -> Result<SaveTimeStampDto, NetworkError> {
        await request(PhotoSaveRouter.saveTimeStamp(fileName: fileName, size: size, objectKey: objectKey, category: category, visibility: visibility, originalTakenAt: originalTakenAt))
    }
}
