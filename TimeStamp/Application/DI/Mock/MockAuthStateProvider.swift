//
//  MockAuthStateProvider.swift
//  TimeStamp
//
//  Created by 임주희 on 11/24/26.
//

import Foundation
import Combine


final class MockAuthStateProvider: AuthStateProviding {
    private let isLoggedInSubject: CurrentValueSubject<Bool, Never>
    private let currentUserSubject: CurrentValueSubject<User?, Never>

    var isLoggedIn: Bool {
        isLoggedInSubject.value
    }

    var currentUser: User? {
        currentUserSubject.value
    }

    var isLoggedInPublisher: AnyPublisher<Bool, Never> {
        isLoggedInSubject.eraseToAnyPublisher()
    }

    var currentUserPublisher: AnyPublisher<User?, Never> {
        currentUserSubject.eraseToAnyPublisher()
    }

    init(
        isLoggedIn: Bool = false,
        currentUser: User? = nil
    ) {
        self.isLoggedInSubject = CurrentValueSubject(isLoggedIn)
        self.currentUserSubject = CurrentValueSubject(currentUser)
    }

    func updateLoginState(
        isLoggedIn: Bool,
        currentUser: User?
    ) {
        isLoggedInSubject.send(isLoggedIn)
        currentUserSubject.send(currentUser)
    }
}
