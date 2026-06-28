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
    private let originLog: TimeStampLogViewData
    private let categoryMapper = CategoryMapper()

    // MARK: - Dependencies
    private let useCase: LogDetailUseCaseProtocol
    var onDeleteSuccess: (() -> Void)?

    init(log: TimeStampLogViewData, useCase: LogDetailUseCaseProtocol) {
        self.originLog = log
        self.detail = log
        self.useCase = useCase
        self.category = log.category
        self.visibility = log.visibility
    }
    
    // MARK: - Output Properties
    @Published var detail: TimeStampLogViewData
    @Published var category: CategoryViewData
    @Published var visibility: VisibilityViewData
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    
    // 공유하기
    @Published var shareImage: UIImage?
    @Published var isPreparingShare = false
    
    
    
    /// 전체공개버튼 노출 여부
    /// - note: 서버데이터 일 때만 노출
    func isPublicVisibility() ->  Bool {
        if case .remote = originLog.imageSource {
            return true
        }
        return false
    }

    // MARK: - Input Methods
    func fetchDetail() {
        guard !isLoading else { return }

        // 저장 위치 확인 (로컬, 서버)
        switch originLog.imageSource {
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
        switch originLog.imageSource {
        case .remote:
            deleteLogFromServer()

        case .local:
            deleteLogFromLocal()
        }
    }
    
    func updateLog() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                // ViewData를 Entity로 변환
                let categoryEntity = categoryMapper.toEntity(from: category)
                let visibilityEntity = VisibilityTypeMapper().toEntity(from: visibility)
                
                switch originLog.imageSource {
                case let .remote(remoteImage): // 서버 로그 수정
                    let result = try await useCase.editLogForServer(
                        logId: remoteImage.id,
                        category: categoryEntity,
                        visibility: visibilityEntity
                    )
                    Logger.success("서버 로그 수정 성공: \(result)")
                    
                    // 앰플리튜드
                    // 비공개 -> 전체공개가 된 경우..
                    if originLog.visibility == .privateVisible &&
                        visibility == .publicVisible {
                        AmplitudeManager.shared.trackPublicPhotoUpload(category: categoryEntity)
                    }
                    
                case .local:
                    // 로컬 로그 수정
                    try useCase.editLogForLocal(
                        logId: originLog.id,
                        category: categoryEntity,
                        visibility: visibilityEntity
                    )
                    Logger.success("로컬 로그 수정 성공")
                }
                toastMessage = "수정되었습니다."
            } catch {
                Logger.error("로그 수정 실패: \(error)")
                show(.editFailed)
            }
            isLoading = false
        }
    }

    
    // MARK: - private Methods
    
    private func fetchDetailFromServer() {
        guard case let .remote(remoteImage) = originLog.imageSource else {
            return
        }
        isLoading = true
        let logServerId = remoteImage.id
        Task { @MainActor in
            do {
                let entity = try await useCase.fetchLogDetailFromServer(logId: logServerId)
                let detailViewData = entity.toViewData()
                detail = detailViewData
                visibility = detailViewData.visibility
                category = detailViewData.category
                Logger.success("로그 상세 정보 가져오기 성공 (서버)")
            } catch {
                Logger.error("서버 로그 상세 정보 가져오기 실패: \(error)")
                show(.unknownRequestFailed)
            }
            isLoading = false
        }
    }

    private func fetchDetailFromLocal() {
        guard case .local = originLog.imageSource else {
            return
        }
        isLoading = true
        Task { @MainActor in
            do {
                let entity = try useCase.fetchLogFromLocal(logId: originLog.id)
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
        guard case let .remote(remoteImage) = originLog.imageSource else {
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
        guard case .local = originLog.imageSource else {
            return
        }
        Task { @MainActor in
            isLoading = true
            do {
                try await useCase.deleteLogFromLocal(logId: originLog.id)
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
                let image = try await useCase.prepareImageForSharing(imageSource: originLog.imageSource)
                shareImage = image
            } catch {
                toastMessage = "공유에 실패했어요. 다시 시도해 주세요."
            }
            isPreparingShare = false
            isLoading = false
        }
    }

    // MARK: - 다운로드

    /// 사진을 갤러리에 저장
    func downloadImage() {
        guard !isLoading else { return }

        isLoading = true

        Task { @MainActor in
            do {
                let image = try await useCase.prepareImageForSharing(imageSource: detail.imageSource)
                let photoSaveRepository = AppDIContainer.shared.makePhotoSaveRepository()
                photoSaveRepository.savePhotoToGallery(image: image)
                toastMessage = "사진이 저장되었어요."
            } catch {
                Logger.error("사진 저장 실패: \(error)")
                toastMessage = "사진 저장에 실패했어요."
            }
            isLoading = false
        }
    }
}
