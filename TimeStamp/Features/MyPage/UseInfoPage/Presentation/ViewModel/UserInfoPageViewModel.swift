//
//  UserInfoPageViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 1/3/26.
//


import Combine

final class UserInfoPageViewModel: ObservableObject, MessageDisplayable {
    private let withdrawalUseCase: WithdrawalUseCaseProtocol

    init(withdrawalUseCase: WithdrawalUseCaseProtocol) {
        self.withdrawalUseCase = withdrawalUseCase
    }

    // MARK: - Output Properties

    /// 로딩
    @Published var isLoading: Bool = false

    /// 에러 메시지
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    /// 회원탈퇴 성공
    @Published var withdrawalSuccess: Bool = false

    // MARK: - Input Methods

    func signout() {
        guard !isLoading else { return }

        Logger.debug("회원탈퇴 시작")
        Task {
            await performWithdrawal()
        }
    }

    // MARK: - Private Methods

    @MainActor
    private func performWithdrawal() async {
        isLoading = true

        do {
            try await withdrawalUseCase.withdrawal()
            Logger.success("회원탈퇴 성공")
            ToastManager.shared.show(AppMessage.withdrawalSuccess.text)

            // 로그아웃 처리
            AuthManager.shared.logout()

            isLoading = false
            withdrawalSuccess = true
            
        } catch {
            isLoading = false
            show(.signoutFailed)
            Logger.error("회원탈퇴 실패: \(error)")
        }
    }
}
