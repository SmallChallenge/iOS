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
        
        // 저장 위치 확인 (로컬, 서버)
        switch log.imageSource {
        case .remote:
            deleteLogFromServer()
            
        case .local: break
        }
    }
    
    /// 서버의 기록 지우기
    private func deleteLogFromServer() {
        Task { @MainActor in
            // 서버 이미지만 삭제 가능
            guard case let .remote(remoteImage) = log.imageSource else {
                toastMessage = "로컬 이미지는 삭제할 수 없습니다"
                return
            }

            isLoading = true
            do {
                try await useCase.deleteLogFromServer(logId: remoteImage.id)
                isLoading = false
                toastMessage = "삭제되었습니다"
                onDeleteSuccess?()
            } catch {
                isLoading = false
                //handleError(error as? NetworkError ?? .unknownError)
            }
        }
    }
    
    /// 로컬 기록 지우기
    private func deleteLogFromLocal() {
        
    }
}
