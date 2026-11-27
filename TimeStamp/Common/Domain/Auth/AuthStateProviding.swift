//
//  AuthStateProviding.swift
//  TimeStamp
//
//  Created by 임주희 on 11/24/26.
//

import Foundation
import Combine

// 로그인 상태와 사용자 정보를 조회하고 관찰하기 위한 Protocol
// view,viewModel 에서 로그인,로그아웃할 때 UI가 즉시 바뀌어야 하므로 AuthStateProviding을 사용
protocol AuthStateProviding {
    var isLoggedIn: Bool { get }
    var currentUser: User? { get }

    var isLoggedInPublisher: AnyPublisher<Bool, Never> { get }
    var currentUserPublisher: AnyPublisher<User?, Never> { get }
}



