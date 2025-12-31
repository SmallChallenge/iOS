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

    // MARK: - Common Dependencies

    private lazy var localTimeStampLogDataSource: LocalTimeStampLogDataSourceProtocol = {
        LocalTimeStampLogDataSource()
    }()

    private lazy var settingsDataSource: SettingsDataSourceProtocol = {
        SettingsDataSource()
    }()

    // MARK: - LaunchScreen Feature

    private lazy var launchScreenDIContainer: LaunchScreenDIContainer = {
        LaunchScreenDIContainer(
            authApiClient: authApiClient,
            appContainer: self
        )
    }()

    func makeLaunchScreenView() -> LaunchScreenView {
        return launchScreenDIContainer.makeLaunchScreenView()
    }
    
    
    // MARK: - MyLog Feature

    private lazy var myLogDIContainer: MyLogDIContainer = {
        return MyLogDIContainer(
            session: session,
            localDataSource: localTimeStampLogDataSource,
            settingsRepository: settingsDataSource
        )
    }()

    func makeMainTabView() -> MainTabView {
        return myLogDIContainer.makeMainTabView()
    }
    func makeMyLogView() -> MyLogView {
        return myLogDIContainer.makeMyLogView()
    }

    // MARK: - Camera Feature

    private lazy var cameraTabDIContainer: CameraDIContainer = {
        return CameraDIContainer(session: session, localDataSource: localTimeStampLogDataSource)
    }()

    func makeCameraTapView(onDismiss: @escaping () -> Void) -> CameraTabView {
        return cameraTabDIContainer.makeCameraTabView(onDismiss: onDismiss)
    }
   
    // MARK: - Community Feature

    func makeCommunityView() -> CommunityView {
        // TODO: ViewModel이 필요하면 여기서 주입
        return CommunityView()
    }
    
    // MARK: - MyPage Feature
    
    private lazy var myPageDIContainer: MyPageDIContainer = {
        return MyPageDIContainer(authApiClient: authApiClient)
    }()
    
    func makeMyPageView() -> MyPageView {
        myPageDIContainer.makeMyPageView()
    }
    
    // MARK: - Login Feature

    private lazy var loginDIContainer: LoginDIContainer = {
        LoginDIContainer(authApiClient: authApiClient)
    }()

    func makeLoginView(onDismiss: @escaping () -> Void) -> LoginView {
        return loginDIContainer.makeLoginView(onDismiss: onDismiss)
    }

}
