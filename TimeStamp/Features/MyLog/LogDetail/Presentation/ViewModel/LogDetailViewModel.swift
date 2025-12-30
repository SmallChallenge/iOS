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

    init(log: TimeStampLogViewData) {
        self.log = log

    }
    
    // MARK: - Input Methods
    
    ///  로그 삭제하기
    func deleteLog(){
        // TODO: 로그 삭제하기
    }
}
