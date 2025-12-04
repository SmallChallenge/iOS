//
//  ApiClient.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
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
        let request: URLRequest
        do {
            request = try router.asURLRequest()
        } catch {
            return .failure(.urlError)
        }
        
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

        guard let data = result.data else {
            return .failure(.dataNil)
        }

        guard let response = result.response else {
            return .failure(.invalidResponse)
        }

        if 200..<300 ~= response.statusCode {
            // 1) ResponseBody<T> 시도
            if let wrapped = try? decoder.decode(ResponseBody<T>.self, from: data) {
                if let payload = wrapped.data {
                    return .success(payload)
                } else {
                    return .failure(.dataNil)
                }
            }
            // 2) T 직접 디코딩 폴백
            if let direct = try? decoder.decode(T.self, from: data) {
                return .success(direct)
            }

            // 디코딩 실패 시 raw data 출력 (디버깅용)
            #if DEBUG
            if let jsonString = String(data: data, encoding: .utf8) {
                print(">>>>>❌ Decoding failed for: \(jsonString)")
            }
            #endif

            return .failure(.failToDecode("Unable to decode as ResponseBody or direct T"))

        } else { // 실패
            return .failure(.serverError(response.statusCode))
        }
    }
    
    
}

