//
//  MyPageDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
protocol MyPageDIContainerProtocol {
    func makeMyPageView() -> MyPageView
    func makeUseInfoPageView(onGoBack: @escaping (_ needRefresh: Bool) -> Void) -> UseInfoPageView
    
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
    func makeUseInfoPageView(onGoBack: @escaping (_ needRefresh: Bool) -> Void) -> UseInfoPageView {
        return UseInfoPageView(onGoBack: onGoBack)
    }
}
struct MockMyPageDIContainer: MyPageDIContainerProtocol{
    func makeMyPageView() -> MyPageView {
        let vm = MyPageViewModel()
        return MyPageView(viewModel: vm, diContainer: self)
    }
    
    func makeUseInfoPageView(onGoBack: @escaping (_ needRefresh: Bool) -> Void) -> UseInfoPageView {
        return UseInfoPageView(onGoBack: onGoBack)
    }
}
