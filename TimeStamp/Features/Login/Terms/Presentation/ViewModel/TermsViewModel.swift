//
//  TermsViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import Foundation
import Combine

final class TermsViewModel: ObservableObject, MessageDisplayable {
    
    
    
    private let usecase: TermsUseCaseProtocol
    init(usecase: TermsUseCaseProtocol) {
        self.usecase = usecase
    }
    
    @Published var isLoading: Bool = false
    @Published var isActive: Bool = false
    
    @Published var toastMessage: String?
    @Published var alertMessage: String?
    
    // Input Method
    func saveTerms(accessToken token: String?, isCheckedOfService: Bool, isCheckedOfPrivacy: Bool, isCheckedOfMarketing: Bool){
        guard !isLoading, let token else { return }
        isLoading = true
        
        Task {
            do {
                let result = try await usecase.activeAccount(
                    accessToken: token,
                    agreedToPrivacyPolicy: isCheckedOfPrivacy,
                    agreedToTermsOfService: isCheckedOfService,
                    agreedToMarketing: isCheckedOfMarketing
                )
                await MainActor.run {
                    isLoading = false
                    isActive = (result.userStatus == .active)
                    Logger.success("계정 활성화: \(result.userStatus)")
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    isActive = false
                    show(.unknownRequestFailed)
                    Logger.error("계정 활성화 실패: \(error)")
                }
            }
        }
        
        
    }
}
