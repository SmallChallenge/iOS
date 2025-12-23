//
//  LaunchScreenUseCase.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation

protocol LaunchScreenUseCaseProtocol {
    func refreshToken() async
    func getUserInfo() async
}

// usecase -> viewModel
protocol LaunchScreenUseCaseDelegate: AnyObject {
    func didRefreshToken(success: Bool)
}

class LaunchScreenUseCase: LaunchScreenUseCaseProtocol {
    private let repository: LaunchScreenRepositoryProtocol
    weak var delegate: LaunchScreenUseCaseDelegate?

    init(repository: LaunchScreenRepositoryProtocol) {
        self.repository = repository
    }

    /// 토큰 갱신 (비동기 비즈니스 로직)
    func refreshToken() async {
        // 1. 저장된 Refresh Token 확인
        guard let refreshToken = AuthManager.shared.getRefreshToken() else {
            // 토큰 없음 → 로그인 필요
            await notifyDelegate(success: false)
            return
        }

        // 2. 토큰 갱신 요청 (백그라운드에서 실행)
        let result = await repository.refreshToken(token: refreshToken)

        switch result {
        case .success(let entity):
            // 3. 새 토큰으로 업데이트 (AuthManager가 메인 스레드 처리)
            AuthManager.shared.refreshToken(
                accessToken: entity.accessToken,
                refreshToken: entity.refreshToken
            )

            // 유저정보 갱신
            await getUserInfo()
            
            await notifyDelegate(success: true)

        case .failure:
            await notifyDelegate(success: false)
        }
    }

    /// 사용자 정보 가져오기 (비동기 비즈니스 로직)
    func getUserInfo() async {
        // TODO: 사용자 정보 가져오기 API 구현 필요
        // 현재는 AuthManager에 저장된 정보만 사용
        /*
          let result = await repository.getUserInfo(...)
          switch result {
          case .success(let userEntity):
              // 유저 정보만 저장, Delegate 호출 안함
              AuthManager.shared.updateUser(user)
          case .failure(let error):
              print("❌ 유저 정보 실패: \(error)")
              // 실패해도 Delegate 호출 안함 (토큰은 갱신됐으니)
         */
    }

    /// Delegate 호출 (메인 스레드로 전환)
    private func notifyDelegate(success: Bool) async {
        await MainActor.run {
            delegate?.didRefreshToken(success: success)
        }
    }
}
