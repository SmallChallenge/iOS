//
//  LogDetailViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/30/25.
//

import Foundation
import Combine
import UIKit

final class LogDetailViewModel: ObservableObject, MessageDisplayable {

    
    @Published var log: TimeStampLogViewData
    
    // MARK: - Output Properties
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    
    // 공유하기
    @Published var shareImage: UIImage?
    @Published var isPreparingShare = false

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
                onDeleteSuccess?()
                ToastManager.shared.show(AppMessage.deleteSuccess.text)
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
                onDeleteSuccess?()
                ToastManager.shared.show(AppMessage.deleteSuccess.text)
            } catch {
                isLoading = false
                show(.deleteFailed)
            }
        }
    }

    // MARK: - 공유하기

    /// 공유할 이미지 준비
    func prepareImageForSharing() {
        guard !isPreparingShare else { return }

        // 이미 이미지가 있으면 재사용
        if shareImage != nil {
            return
        }

        isPreparingShare = true
        isLoading = true

        Task { @MainActor in
            do {
                let image = try await useCase.prepareImageForSharing(imageSource: log.imageSource)
                shareImage = image
            } catch {
                ToastManager.shared.show("이미지를 불러올 수 없습니다")
            }
            isPreparingShare = false
            isLoading = false
        }
    }
}
