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

    private lazy var communityApiClient: CommunityApiClientProtocol = {
        CommunityApiClient(session: session)
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

    private lazy var communityDIContainer: CommunityDiContainer = {
        return CommunityDiContainer(communityApiClient: communityApiClient)
    }()

    func makeCommunityView() -> CommunityView {
        return communityDIContainer.makeCommunityView()
    }
    
    // MARK: - MyPage Feature
    
    private lazy var myPageDIContainer: MyPageDIContainer = {
        return MyPageDIContainer(authApiClient: authApiClient)
    }()
    
    func makeMyPageView(onGoBack: @escaping () -> Void) -> MyPageView {
        myPageDIContainer.makeMyPageView(onGoBack: onGoBack)
    }
    
    // MARK: - Login Feature

    private lazy var loginDIContainer: LoginDIContainer = {
        LoginDIContainer(authApiClient: authApiClient)
    }()

    func makeLoginView(onDismiss: @escaping () -> Void) -> LoginView {
        return loginDIContainer.makeLoginView(onDismiss: onDismiss)
    }
    /// 닉네임 설정 화면
    /// - Parameters:
    ///   - onGoBack: 로그인 로직에선 그냥 뒤로감, 마이페이지 로직에선 새로고침 여부 보냄
    ///   - onDismiss: 로그인 로직에서, 로그인 뷰 닫기
    /// - Returns:
    func makeNicknameSettingView(loginEntity: LoginEntity?, onGoBack: @escaping (_ needRefresh: Bool) -> Void, onDismiss: (()-> Void)?) -> NicknameSettingView {
        return loginDIContainer.makeNicknameSettingView(loginEntity: loginEntity, onGoBack: onGoBack, onDismiss: onDismiss)
    }
    // MARK: - Terms WebView

    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView {
        return AnyView(
            NavigationStack {
                AdvancedWebView(
                    url: URL(string: url)!,
                    isLoading: .constant(false)
                )
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            onDismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        )
    }
}
