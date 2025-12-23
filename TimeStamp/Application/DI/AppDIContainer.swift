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

    // MARK: - LaunchScreen Feature

    func makeLaunchScreenView() -> LaunchScreenView {
        let repository = LaunchScreenRepository(authApiClient: authApiClient)
        let useCase = LaunchScreenUseCase(repository: repository)
        let viewModel = LaunchScreenViewModel(useCase: useCase)
        useCase.delegate = viewModel
        return LaunchScreenView(viewModel: viewModel)
    }

    // MARK: - Login Feature

    private lazy var loginDIContainer: LoginDIContainer = {
        LoginDIContainer(authApiClient: authApiClient)
    }()

    func makeLoginView() -> LoginView {
        return loginDIContainer.makeLoginView()
    }

    // MARK: - Camera Feature

    private lazy var cameraTabDIContainer: CameraTabDIContainer = {
        CameraTabDIContainer()
    }()

    func makeCameraTapView(onDismiss: @escaping () -> Void) -> CameraTabView {
        return cameraTabDIContainer.makeCameraTabView(onDismiss: onDismiss)
    }

    // MARK: - SavePhoto Feature

    func makeSavePhotoView(capturedImage: UIImage, onDismiss: @escaping () -> Void, onGoBack: (() -> Void)? = nil) -> SavePhotoView {
        let localRepository = LocalTimeStampLogRepository()
        let repository = SavePhotoRepository(localRepository: localRepository)
        let useCase = SavePhotoUseCase(repository: repository)
        let viewModel = SavePhotoViewModel(useCase: useCase)
        return SavePhotoView(
            viewModel: viewModel,
            capturedImage: capturedImage,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }

    // MARK: - MyLog Feature

    private lazy var myLogDIContainer: MyLogDIContainer = {
        let localRepository = LocalTimeStampLogRepository()
        return MyLogDIContainer(localRepository: localRepository)
    }()

    func makeMyLogView() -> MyLogView {
        return myLogDIContainer.makeMyLogView()
    }

    // MARK: - Community Feature

    func makeCommunityView() -> CommunityView {
        // TODO: ViewModel이 필요하면 여기서 주입
        return CommunityView()
    }
}
