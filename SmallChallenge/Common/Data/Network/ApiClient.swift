//
//  ApiClient.swift
//  SmallChallenge
//
//  Created by 임주희 on 11/27/25.
//

import Foundation
import Alamofire

public class ApiClient<R: Router> {
    private let session: Session
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    public init(
        session: Session,
        decoder: JSONDecoder = {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return decoder
        }(),
        encoder: JSONEncoder = JSONEncoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
    }

    public func request<T: Decodable>(_ router: R) async -> Result<T, NetworkError> {
        let request = router.asURLRequest()
        let result = await session.request(request).serializingData().response
        
        // 에러 처리
        if let error = result.error {
            if let afError = error.asAFError {
                switch afError {
                case .sessionTaskFailed(let underlying as URLError) where underlying.code == .notConnectedToInternet:
                    return .failure(.noInternet)
                case .explicitlyCancelled:
                    return .failure(.cancelled)
                default:
                    return .failure(.requestFailed(afError.localizedDescription))
                }
            }
            return .failure(.requestFailed(error.localizedDescription))
        }
        
        
        guard let data = result.data
        else { return .failure(.dataNil)}
        
        guard let response = result.response else {
            return .failure(.invalidResponse)
        }
        
        // 성공한 경우
        if 200..<400 ~= response.statusCode {
            do {
                let decodedResponse = try JSONDecoder().decode(ResponseBody<T>.self, from: data)
                if let responseData = decodedResponse.data {
                    return .success(responseData)
                } else {
                    return .failure(.dataNil)
                }
            } catch {
                return .failure(.failToDecode(error.localizedDescription))
            }
        } else { // 실패
            return .failure(.serverError(response.statusCode))
            
        }
    }
    
    
}

