//
//  LogDetailViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/30/25.
//

import Foundation
import Combine

final class LogDetailViewModel: ObservableObject, MessageDisplayable {

    // MARK: - Output Properties
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    // TODO: 데이터 수정하기
    @Published var log: TimeStampLogViewData
    @Published var category: CategoryViewData = .food
    @Published var visibility: VisibilityViewData = .privateVisible

    // MARK: - Dependencies
    private let useCase: LogDetailUseCaseProtocol
    var onDeleteSuccess: (() -> Void)?

    init(log: TimeStampLogViewData, useCase: LogDetailUseCaseProtocol) {
        self.log = log
        self.useCase = useCase
    }

    // MARK: - Input Methods

    ///  로그 삭제하기
    func deleteLog() {
        guard !isLoading else { return }

        // 저장 위치 확인 (로컬, 서버)
        switch log.imageSource {
        case .remote:
            deleteLogFromServer()

        case .local:
            deleteLogFromLocal()
        }
    }

    /// 서버의 기록 지우기
    private func deleteLogFromServer() {
        guard case let .remote(remoteImage) = log.imageSource else {
            return
        }

        Task { @MainActor in
            isLoading = true
            do {
                try await useCase.deleteLogFromServer(logId: remoteImage.id)
                isLoading = false
                show(.photoDeleteSuccess)
                onDeleteSuccess?()
            } catch {
                isLoading = false
                show(.deleteFailed)
            }
        }
    }

    /// 로컬 기록 지우기
    private func deleteLogFromLocal() {
        Task { @MainActor in
            isLoading = true
            do {
                try await useCase.deleteLogFromLocal(logId: log.id)
                isLoading = false
                show(.photoDeleteSuccess)
                onDeleteSuccess?()
            } catch {
                isLoading = false
                show(.deleteFailed)
            }
        }
    }
}
