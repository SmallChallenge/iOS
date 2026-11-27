//
//  AuthRepositoryProtocol.swift
//  TimeStamp
//
//  Created by 임주희 on 11/24/26.
//

import Foundation

protocol AuthRepositoryProtocol {
    func isLoggedIn() -> Bool
    func fetchCurrentUser() -> User?
}

