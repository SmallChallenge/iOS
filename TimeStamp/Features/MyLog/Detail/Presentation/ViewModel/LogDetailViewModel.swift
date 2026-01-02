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

    /// origin data
    private let log: TimeStampLogViewData
    @Published var detail: TimeStampLogViewData


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
        self.detail = log
        self.useCase = useCase
    }
    

    // MARK: - Input Methods
    func fetchDetail() {
        guard !isLoading else { return }

        // 저장 위치 확인 (로컬, 서버)
        switch log.imageSource {
        case .remote:
            fetchDetailFromServer()
        case .local:
            fetchDetailFromLocal()
        }
    }
    
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

    
    // MARK: - private Methods
    
    private func fetchDetailFromServer() {
        guard case let .remote(remoteImage) = log.imageSource else {
            return
        }
        isLoading = true
        let logServerId = remoteImage.id
        Task { @MainActor in
            do {
                let entity = try await useCase.fetchLogDetailFromServer(logId: logServerId)
                detail = entity.toViewData()
                Logger.success("로그 상세 정보 가져오기 성공 (서버)")
            } catch {
                Logger.error("서버 로그 상세 정보 가져오기 실패: \(error)")
                show(.unknownRequestFailed)
            }
            isLoading = false
        }
    }

    private func fetchDetailFromLocal() {
        guard case .local = log.imageSource else {
            return
        }
        isLoading = true
        Task { @MainActor in
            do {
                let entity = try useCase.fetchLogFromLocal(logId: log.id)
                detail = entity.toViewData()
                Logger.success("로그 상세 정보 가져오기 성공 (로컬)")
            } catch {
                Logger.error("로컬 로그 상세 정보 가져오기 실패: \(error)")
                show(.unknownRequestFailed)
            }
            isLoading = false
        }
    }
    
    
    /// 서버의 기록 지우기
    private func deleteLogFromServer() {
        guard case let .remote(remoteImage) = log.imageSource else {
            return
        }
        isLoading = true
        Task { @MainActor in
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
        guard case .local = log.imageSource else {
            return
        }
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
