//
//  LoginRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

struct LoginRepository: LoginRepositoryProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    func kakaoLogin(accessToken token: String) async -> Result<LoginEntity, NetworkError> {
        let result = await authApiClient.kakaoLogin(accessToken: token)
        return mapToEntity(result)
    }

    func appleLogin(accessToken token: String) async -> Result<LoginEntity, NetworkError> {
        let result = await authApiClient.appleLogin(accessToken: token)
        return mapToEntity(result)
    }

    func googleLogin(accessToken token: String) async -> Result<LoginEntity, NetworkError> {
        let result = await authApiClient.googleLogin(accessToken: token)
        return mapToEntity(result)
    }

    // MARK: - Private Methods

    private func mapToEntity(_ result: Result<LoginResponseDto, NetworkError>) -> Result<LoginEntity, NetworkError> {
        switch result {
        case .success(let dto):
            guard let entity = LoginMapper.toEntity(from: dto) else {
                return .failure(.failToDecode("Invalid socialType"))
            }
            return .success(entity)
        case .failure(let error):
            return .failure(error)
        }
    }
}
