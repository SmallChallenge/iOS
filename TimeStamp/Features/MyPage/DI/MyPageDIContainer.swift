//
//  MyPageDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation

final class MyPageDIContainer {
    
    // MARK: - Dependencies
    private let authApiClient: AuthApiClientProtocol
    
    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    // MARK: - Repository
    private func makeMyPageRepository(){
        
    }
    
    // MARK: - UseCase
    private func makeMyPageUseCase() {
        
    }
    
    // MARK: - ViewModel
    private func makeMyPageViewModel() {
        
    }
    
    // MARK: - View
    func makeMyPageView() -> MyPageView {
        MyPageView()
    }
}
