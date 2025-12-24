//
//  MyPageViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
import Combine

final class MyPageViewModel: ObservableObject {
    
    
    // MARK: - Output Properties
    
    @Published var isLoading = false
    @Published var errorMessage: String?

    
    // MARK: - Input Methods
    
    func logout(){
        AuthManager.shared.logout()
        
    }
}
