//
//  MyPageDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
protocol MyPageDIContainerProtocol {
    func makeMyPageView() -> MyPageView
    func makeUserInfoPageView(onGoBack: @escaping (_ needRefresh: Bool) -> Void) -> UserInfoPageView
    
}
final class MyPageDIContainer: MyPageDIContainerProtocol {
    
    // MARK: - Dependencies
    private let authApiClient: AuthApiClientProtocol
    
    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    // MARK: - MyPageView
    private func makeMyPageRepository(){
        
    }
    private func makeMyPageUseCase() {
        
    }
    private func makeMyPageViewModel() -> MyPageViewModel {
        MyPageViewModel()
    }
    
    
    func makeMyPageView() -> MyPageView {
        let vm = makeMyPageViewModel()
        return MyPageView(viewModel: vm, diContainer: self)
    }
    // MARK: - UseInfoPageView
    func makeUserInfoPageView(onGoBack: @escaping (_ needRefresh: Bool) -> Void) -> UserInfoPageView {
        return UserInfoPageView(onGoBack: onGoBack)
    }
}
struct MockMyPageDIContainer: MyPageDIContainerProtocol{
    func makeMyPageView() -> MyPageView {
        let vm = MyPageViewModel()
        return MyPageView(viewModel: vm, diContainer: self)
    }
    
    func makeUserInfoPageView(onGoBack: @escaping (_ needRefresh: Bool) -> Void) -> UserInfoPageView {
        return UserInfoPageView(onGoBack: onGoBack)
    }
}
