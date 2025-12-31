//
//  MainTabViewModel.swift
//  TimeStamp
//
//  Created by Claude on 12/31/24.
//

import Foundation
import Combine

@MainActor
final class MainTabViewModel: ObservableObject {

    // MARK: - Properties
    private var authManager = AuthManager.shared
    private let myLogUseCase: MyLogUseCaseProtocol

    // MARK: - Init

    init(myLogUseCase: MyLogUseCaseProtocol) {
        self.myLogUseCase = myLogUseCase
    }

    // MARK: - Methods

    /// 로컬 기록 개수 확인
    /// - Returns: 로컬에 저장된 기록 개수
    func getLocalLogsCount() -> Int {
        return myLogUseCase.getLocalLogsCount()
    }

    /// 카메라 촬영 가능 여부 확인 (로컬 기록이 20개 미만인지)
    ///  비로그인 상태로, 로컬기록이 20개 이상이면 -> false
    /// - Returns: 촬영 가능하면 true, 제한에 도달하면 false
    func canTakePhoto() -> Bool {
        return authManager.isLoggedIn || getLocalLogsCount() < AppConstants.Limits.maxLogCount
    }
}
