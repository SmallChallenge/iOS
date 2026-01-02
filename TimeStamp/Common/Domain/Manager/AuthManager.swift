//
//  AuthManager.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import Foundation
import Combine

/// 로그인 상태와 사용자 정보를 관리
final class AuthManager: ObservableObject {

    static let shared = AuthManager()

    // MARK: - Storage (Keychain, UserDefaults)

    @Keychain(key: "accessToken") private var accessToken: String?
    @Keychain(key: "refreshToken") private var refreshToken: String?

    @UserDefaultsWrapper<User>(key: "currentUser") private var storedUser: User?
    @UserDefaultsValue(key: "isLoggedIn", defaultValue: false) private var storedIsLoggedIn: Bool

    // MARK: - Published Properties

    /// 현재 로그인 여부 (View에서 구독 가능)
    @Published private(set) var isLoggedIn: Bool = false

    /// 현재 사용자 정보 (View에서 구독 가능)
    @Published private(set) var currentUser: User?

    // MARK: - Init

    private init() {
        // 앱 시작 시 저장된 로그인 상태 복원
        loadLoginState()
    }

    // MARK: - Public Methods

    /// 로그인 성공 시 호출 (토큰 + 사용자 정보 저장)
    func login(user: User, accessToken: String, refreshToken: String) {
        // 1. 토큰 저장 (Keychain)
        self.accessToken = accessToken
        self.refreshToken = refreshToken

        // 2. 사용자 정보 저장 (UserDefaults)
        storedUser = user
        storedIsLoggedIn = true

        // 3. 상태 업데이트
        currentUser = user
        isLoggedIn = true

        Logger.success("로그인 성공: \(user.nickname ?? "익명") (userId: \(user.userId))")

        // 4. MyLogView 새로고침 알림
        NotificationCenter.default.post(name: .shouldRefreshMyLog, object: nil)
    }
    
    /// 토큰갱신
    func refreshToken(accessToken: String, refreshToken: String){
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    /// 로그아웃
    func logout() {
        // 1. 토큰 삭제
        accessToken = nil
        refreshToken = nil

        // 2. 사용자 정보 삭제
        storedUser = nil
        storedIsLoggedIn = false

        // 3. 상태 업데이트
        currentUser = nil
        isLoggedIn = false
        
        // 4. MyLogView 새로고침 알림
        NotificationCenter.default.post(name: .shouldRefreshMyLog, object: nil)
        Logger.success("로그아웃 완료")
    }

    /// Access Token 가져오기 (API 호출 시 사용)
    func getAccessToken() -> String? {
        return accessToken
    }

    /// Refresh Token 가져오기
    func getRefreshToken() -> String? {
        return refreshToken
    }

    // MARK: - Private Methods

    /// 앱 시작 시 저장된 로그인 상태 복원
    private func loadLoginState() {
        isLoggedIn = storedIsLoggedIn
        currentUser = storedUser

        if isLoggedIn {
            Logger.success("저장된 로그인 상태 복원: \(currentUser?.nickname ?? "익명")")
        }
    }
}
