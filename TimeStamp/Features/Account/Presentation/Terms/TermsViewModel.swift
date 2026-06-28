//
//  TermsViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/29/25.
//

import Foundation
import Combine

final class TermsViewModel: ObservableObject, MessageDisplayable {
    private let loginEntity: LoginEntity?
    private let usecase: TermsUseCaseProtocol
    init(usecase: TermsUseCaseProtocol, pendingLoginEntity: LoginEntity?) {
        self.usecase = usecase
        self.loginEntity = pendingLoginEntity
    }
    
    @Published var isLoading: Bool = false
    @Published var isActive: Bool = false
    
    @Published var toastMessage: String?
    @Published var alertMessage: String?
    
    // Input Method
    func saveTerms(isCheckedOfService: Bool, isCheckedOfPrivacy: Bool, isCheckedOfMarketing: Bool){
        guard !isLoading,
              (isCheckedOfService && isCheckedOfPrivacy)
        else { return }
        guard let token = loginEntity?.accessToken else {
            show(.unknownRequestFailed)
            return
        }
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
