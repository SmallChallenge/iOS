//
//  EditorViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 1/8/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class EditorViewModel: ObservableObject, MessageDisplayable {
    private let useCase: EditorUseCaseProtocol
    @Published var isAdReady = false
    @Published var isLoadingAd = false

    /// 광고시청여부
    @Published var hasWatchedAd: Bool  = true // 광고보기 스킵
    /// 로고 있없 여부
    @Published var isOnLogo: Bool  = true
    // 광고보기 팝업 띄우기
    @Published var showAdPopup: Bool  = false

    /// 에러 메시지
    @Published var toastMessage: String?
    @Published var alertMessage: String?

    // MARK: - Constants
    private let maxWaitAttempts = 100 // 최대 대기 시도 횟수
    private let waitInterval: UInt64 = 100_000_000 // 0.1초 (nanoseconds)

    init(useCase: EditorUseCaseProtocol) {
        self.useCase = useCase
    }
    
    /// 로고 토글 탭 이벤트 처리
    func handleLogoToggleTap() {
        // 광고 시청 완료: 자유롭게 설정가능
        guard !hasWatchedAd else {
            isOnLogo = !isOnLogo
            return
        }
        
        // 광고 미시청: 로고 없애려면 광고보기 팝업띄우기
        if isOnLogo {
            showAdPopup = true
        }
    }
    
    // 광고볼래? 팝업 닫기
    func closeAdPopup() {
        showAdPopup = false
    }

    func loadAd() async {
        guard !isAdReady else { return }
        do {
            try await useCase.load()
            isAdReady = true
        } catch {
            print("광고 로드 실패: \(error)")
        }
    }
    
    @MainActor
    func playAd() async {
        guard let topVC = UIApplication.shared.getTopMostViewController() else {
            print("최상단 뷰 컨트롤러를 찾을 수 없습니다.")
            return
        }

        // 광고가 준비되지 않았으면 사용자에게 로딩 표시하며 로드
        if !isAdReady {
            isLoadingAd = true

            // 백그라운드에서 이미 로딩 중일 수 있으므로 완료될 때까지 대기
            for _ in 0..<maxWaitAttempts {
                if isAdReady { break }
                try? await Task.sleep(nanoseconds: waitInterval)
            }

            // 여전히 준비 안됐으면 새로 로드 시도
            if !isAdReady {
                await loadAd()
            }

            isLoadingAd = false

            // 그래도 준비 안됐으면 에러
            guard isAdReady else {
                Logger.error("광고 로드 실패")
                show(.unknownRequestFailed)
                return
            }
        }

        do {
            let reward = try await useCase.execute(from: topVC)
            Logger.success("보상 지급 성공: \(reward)")
            isAdReady = false // 소진되었으므로 다시 로드 필요
            hasWatchedAd = true
            isOnLogo = false
        } catch {
            Logger.error("광고 표시 실패: \(error)")
            show(.unknownRequestFailed)
        }
    }
}
