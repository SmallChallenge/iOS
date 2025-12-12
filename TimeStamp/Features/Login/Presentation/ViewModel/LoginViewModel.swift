//
//  LoginViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/12/25.
//

import Foundation
import Combine

final class LoginViewModel: ObservableObject {
    private let useCase: LoginUseCaseProtocol
    init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // MARK: Output Properties...
    
    
    // MARK: Input Methods...
    
    func clickAppleLoginButton(){
        
    }
}
