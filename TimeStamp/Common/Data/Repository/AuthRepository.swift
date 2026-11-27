//
//  AuthRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 11/24/26.
//


final class AuthRepository: AuthRepositoryProtocol {
    private let authManager: AuthManager

    init(authManager: AuthManager) {
        self.authManager = authManager
    }

    func isLoggedIn() -> Bool {
        authManager.isLoggedIn
    }

    func fetchCurrentUser() -> User? {
        authManager.currentUser
    }
}