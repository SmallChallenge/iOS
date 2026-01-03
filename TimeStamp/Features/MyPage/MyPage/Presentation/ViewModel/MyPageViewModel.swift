//
//  MyPageViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
import Combine

final class MyPageViewModel: ObservableObject, MessageDisplayable {
    
    
    // MARK: - Output Properties
    
    /// 로딩
    @Published var isLoading: Bool = false

    /// 에러 메시지
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    
    // MARK: - Input Methods
    
    func logout(){
        AuthManager.shared.logout()
        
        show(.logoutFailed)
    }
}
