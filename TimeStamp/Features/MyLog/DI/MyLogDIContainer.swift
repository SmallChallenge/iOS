//
//  MyLogDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation
import Alamofire
import UIKit

protocol MyLogDIContainerProtocol {
    func makeMainTabView() -> MainTabView
    func makeMyLogView() -> MyLogView
    func makeLogDetailView(log: TimeStampLogViewData, onGoBack: @escaping () -> Void) -> LogDetailView
    func makeLogEditorView(log: TimeStampLogViewData, onDismiss: @escaping (_ hasEdited: Bool) -> Void) -> LogEditorView

}
struct MyLogDIContainer: MyLogDIContainerProtocol {

    // MARK: - Dependencies

    private let localDataSource: LocalTimeStampLogDataSourceProtocol
    private let session: Session
    private let settingsRepository: SettingsDataSourceProtocol

    // MARK: - Initializer

    init(session: Session, localDataSource: LocalTimeStampLogDataSourceProtocol, settingsRepository: SettingsDataSourceProtocol) {
        self.session = session
        self.localDataSource = localDataSource
        self.settingsRepository = settingsRepository
    }
    
    // MARK: - MainTab
    private func makeMainTabViewModel() -> MainTabViewModel {
        return MainTabViewModel(myLogUseCase: makeMyLogUseCase())
    }

    func makeMainTabView() -> MainTabView {
        return MainTabView(container: AppDIContainer.shared, viewModel: makeMainTabViewModel())
    }
    
    
    // MARK: - MyLog
    private func makeMyLogApiClient() -> MyLogApiClientProtocol {
        return MyLogApiClient(session: session)
    }

    private func makeMyLogRepository() -> MyLogRepositoryProtocol {
        let apiClient = makeMyLogApiClient()
        return MyLogRepository(localDataSource: localDataSource, apiClient: apiClient)
    }

    private func makeMyLogUseCase() -> MyLogUseCaseProtocol {
        return MyLogUseCase(repository: makeMyLogRepository())
    }

    private func makeMyLogViewModel() -> MyLogViewModel {
        return MyLogViewModel(useCase: makeMyLogUseCase(), settingsRepository: settingsRepository)
    }

    func makeMyLogView() -> MyLogView {
        let viewModel = makeMyLogViewModel()
        return MyLogView(viewModel: viewModel, diContainer: self)
    }

    // MARK: - LogDetailView
    private func makeLogDetailApiClient() -> LogDetailApiClientProtocol {
        return LogDetailApiClient(session: session)
    }

    private func makeLogDetailRepository() -> LogDetailRepositoryProtocol {
        let apiClient = makeLogDetailApiClient()
        return LogDetailRepository(apiClient: apiClient, localDataSource: localDataSource)
    }

    private func makeLogDetailUseCase() -> LogDetailUseCaseProtocol {
        return LogDetailUseCase(repository: makeLogDetailRepository())
    }

    private func makeLogDetailViewModel(log: TimeStampLogViewData, onGoBack: @escaping () -> Void) -> LogDetailViewModel {
        let viewModel = LogDetailViewModel(log: log, useCase: makeLogDetailUseCase())
        viewModel.onDeleteSuccess = {
            // 삭제 성공 시 MyLog 새로고침 및 뒤로가기
            NotificationCenter.default.post(name: .shouldRefreshMyLog, object: nil)
            onGoBack()
        }
        return viewModel
    }

    func makeLogDetailView(log: TimeStampLogViewData, onGoBack: @escaping () -> Void) -> LogDetailView {
        let viewModel = makeLogDetailViewModel(log: log, onGoBack: onGoBack)
        return LogDetailView(
            viewModel: viewModel,
            diContainer: self,
            onGoBack: onGoBack
        )
    }
    
    // MARK: - LogEditorView
    private func makeLogEditorViewModel(log: TimeStampLogViewData) -> LogEditorViewModel {
        return LogEditorViewModel(log: log)
    }
    func makeLogEditorView(log: TimeStampLogViewData, onDismiss: @escaping (_ hasEdited: Bool) -> Void) -> LogEditorView {
        let vm = makeLogEditorViewModel(log: log)
        return LogEditorView(viewModel: vm, onDismiss: onDismiss)
    }
}

// MARK: --------------------------------- Mock --------------------------------
struct MockMyLogDIContainer: MyLogDIContainerProtocol {
    
    // MARK: MainTab
    func makeMainTabView() -> MainTabView {
        let useCase = MockMyLogUseCase()
        let viewModel = MainTabViewModel(myLogUseCase: useCase)
        return MainTabView(container: AppDIContainer.shared, viewModel: viewModel)
    }
   
    
    // MARK: MyLogView
    func makeMyLogView() -> MyLogView {
        let usecase = MockMyLogUseCase()
        let settingsRepository = MockSettingsRepository()
        let viewModel = MyLogViewModel(useCase: usecase, settingsRepository: settingsRepository)
        return MyLogView(viewModel: viewModel, diContainer: self)
    }

    struct MockMyLogUseCase: MyLogUseCaseProtocol {
        func getLocalLogsCount() -> Int {
            return 0
        }

        func fetchAllLogs(isLoggedIn: Bool) async -> (logs: [TimeStampLog], pageInfo: PageInfo?) {
            ([], nil)
        }
        func fetchServerLogs(page: Int) async -> (logs: [TimeStampLog], pageInfo: PageInfo?) {
            ([], nil)
        }
    }

    struct MockSettingsRepository: SettingsDataSourceProtocol {
        func getIsLogLimitBannerDismissed() -> Bool {
            return false
        }
        func setIsLogLimitBannerDismissed(_ isDismissed: Bool) {}
    }

   

    // MARK: - LogDetailView
    func makeLogDetailView(log: TimeStampLogViewData, onGoBack: @escaping () -> Void) -> LogDetailView {
        let useCase = MockLogDetailUseCase()
        let viewModel = LogDetailViewModel(log: log, useCase: useCase)
        return LogDetailView(
            viewModel: viewModel, diContainer: self,
            onGoBack: onGoBack
        )
    }
    
    struct MockLogDetailUseCase: LogDetailUseCaseProtocol {
        func deleteLogFromLocal(logId: UUID) async throws {}
        func deleteLogFromServer(logId: Int) async throws {}
        func prepareImageForSharing(imageSource: TimeStampLog.ImageSource) async throws -> UIImage {
            UIImage()
        }
    }
    
    
    // MARK: LogEditorView
    func makeLogEditorView(log: TimeStampLogViewData, onDismiss: @escaping (_ hasEdited: Bool) -> Void) -> LogEditorView {
        return LogEditorView(viewModel: LogEditorViewModel(log: log), onDismiss: onDismiss)
    }
}
