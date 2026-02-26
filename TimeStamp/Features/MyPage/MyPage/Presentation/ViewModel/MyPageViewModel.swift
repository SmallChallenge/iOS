//
//  MyPageViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import Foundation
import Combine

final class MyPageViewModel: ObservableObject, MessageDisplayable {

    // MARK: - Dependencies

    private let logoutUseCase: LogoutUseCaseProtocol

    // MARK: - Output Properties
    
    /// 로그아웃 성공 여부
    @Published var didLogout: Bool = false

    /// 로딩
    @Published var isLoading: Bool = false

    /// 에러 메시지
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    // MARK: - Init

    init(logoutUseCase: LogoutUseCaseProtocol) {
        self.logoutUseCase = logoutUseCase
    }

    // MARK: - Input Methods

    func logout() {
        guard !isLoading else { return }
        Logger.debug("로그아웃 시작")

        Task {
            await performLogout()
        }
    }

    @MainActor
    private func performLogout() async {
        isLoading = true
        
        do {
            try await logoutUseCase.logout()
            Logger.success("로그아웃 성공")
        } catch {
            isLoading = false
            show(.logoutFailed)
            Logger.error("로그아웃 실패: \(error)")
        }
        
        // 로그아웃(api) 성공여부와 상관없이, 로그아웃시키기
        ToastManager.shared.show(AppMessage.logoutSuccess.text)

        // AuthManager에서 로컬 토큰 삭제
        AuthManager.shared.logout()
        AmplitudeManager.shared.logout()
        
        didLogout = true
        isLoading = false
    }
}
