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

    // MARK: - Storage (Keychain only)

    @Keychain(key: "accessToken") private var accessToken: String?
    @Keychain(key: "refreshToken") private var refreshToken: String?

    // MARK: - Published Properties

    /// 현재 로그인 여부 (토큰 유무로 판단)
    @Published private(set) var isLoggedIn: Bool = false

    /// 현재 사용자 정보 (메모리에만 유지, 스플래시에서 API로 받아옴)
    @Published private(set) var currentUser: User?

    // MARK: - Init

    private init() {
        // 앱 시작 시 저장된 로그인 상태 복원
        loadLoginState()
    }

    // MARK: - Public Methods

    /// 로그인 성공 시 호출 (토큰만 Keychain에 저장, 유저 정보는 메모리에만)
    func login(user: User, accessToken: String, refreshToken: String) {
        // 1. 토큰 저장 (Keychain)
        self.accessToken = accessToken
        self.refreshToken = refreshToken

        // 2. 상태 업데이트 (메모리에만)
        currentUser = user
        isLoggedIn = true

        Logger.success("로그인 성공: \(user.nickname ?? "익명") (userId: \(user.userId))")

        // 3. MyLogView 새로고침 알림
        NotificationCenter.default.post(name: .shouldRefresh, object: nil)
    }
    
    
    /// 토큰갱신
    func refreshToken(accessToken: String, refreshToken: String){
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    /// 로그아웃
    func logout() {
        // 1. 토큰 삭제 (Keychain)
        accessToken = nil
        refreshToken = nil

        // 2. 상태 업데이트 (메모리)
        currentUser = nil
        isLoggedIn = false

        // 3. MyLogView 새로고침 알림
        NotificationCenter.default.post(name: .shouldRefresh, object: nil)
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

    /// 닉네임 업데이트
    func updateNickname(_ nickname: String) {
        guard let user = currentUser else { return }
        let updatedUser = User(
            userId: user.userId,
            nickname: nickname,
            socialType: user.socialType,
            profileImageUrl: user.profileImageUrl
        )
        updateUser(updatedUser)
    }

    /// 사용자 정보 업데이트 (메모리에만)
    func updateUser(_ user: User) {
        currentUser = user
        Logger.success("사용자 정보 업데이트: \(user.nickname ?? "익명")")
    }

    // MARK: - Private Methods

    /// 앱 시작 시 저장된 로그인 상태 복원 (토큰만 확인)
    private func loadLoginState() {
        // 토큰 유무로 로그인 상태 판단
        isLoggedIn = accessToken != nil && refreshToken != nil

        if isLoggedIn {
            Logger.info("저장된 토큰 발견 → 스플래시에서 유저 정보 로드 예정")
        } else {
            Logger.info("저장된 토큰 없음 → 로그인 필요")
        }
    }
}
