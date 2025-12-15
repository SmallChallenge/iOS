//
//  AppDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/15/25.
//

import SwiftUI
import Alamofire

/// 앱 전체의 의존성을 관리하고 View를 생성하는 컨테이너
final class AppDIContainer {

    // MARK: - Singleton

    static let shared = AppDIContainer()

    private init() {}

    // MARK: - Network Dependencies

    private lazy var session: Session = {
        let factory = SessionFactory()
        #if DEBUG
        return factory.makeSession(for: .dev)
        #else
        return factory.makeSession(for: .prod)
        #endif
    }()

    private lazy var authApiClient: AuthApiClientProtocol = {
        AuthApiClient(session: session)
    }()

    // MARK: - Login Feature

    func makeLoginView() -> LoginView {
        let repository = LoginRepository(authApiClient: authApiClient)
        let useCase = LoginUseCase(repository: repository)
        let viewModel = LoginViewModel(
            useCase: useCase,
            appleLogin: AppleLogin(),
            kakaoLogin: nil,
            googleLogin: nil
        )
        return LoginView(viewModel: viewModel)
    }

    // MARK: - Camera Feature

    func makeCameraView() -> CameraView {
        // TODO: ViewModel이 필요하면 여기서 주입
        return CameraView()
    }

    // MARK: - MyLog Feature

    func makeMyLogView() -> MyLogView {
        // TODO: ViewModel이 필요하면 여기서 주입
        return MyLogView()
    }

    // MARK: - Community Feature

    func makeCommunityView() -> CommunityView {
        // TODO: ViewModel이 필요하면 여기서 주입
        return CommunityView()
    }
}
