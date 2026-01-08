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
class EditorViewModel: ObservableObject {
    private let useCase: EditorUseCaseProtocol
    @Published var isAdReady = false
    
    /// 광고시청여부
    @Published var hasWatchedAd: Bool  = false
    /// 로고 있없 여부
    @Published var isOnLogo: Bool  = true
    // 광고보기 팝업 띄우기
    @Published var showAdPopup: Bool  = false
    

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

    func loadAd() async {
        guard !isAdReady else { return }
        do {
            try await useCase.load()
            isAdReady = true
        } catch {
            print("광고 로드 실패: \(error)")
        }
    }
    
    func closeAdPopup() {
        showAdPopup = false
    }
    
    

//    func playAd() async {
//        guard let rootVC = UIApplication.shared.connectedScenes
//            .compactMap({ $0 as? UIWindowScene })
//            .first?.windows.first?.rootViewController else { return }
//        
//        do {
//            let amount = try await useCase.execute(from: rootVC)
//            print(">>>>> amount: \(amount)")
//            isAdReady = false // 소진되었으므로 다시 로드 필요
//            
//            // 광고봤음.
//            hasWatchedAd = true
//        } catch {
//            Logger.error("광고 표시 실패: \(error)")
//        }
//    }
    
    @MainActor
    func playAd() async {
        // 1. rootViewController 대신 'TopMost'를 찾습니다.
        guard let topVC = UIApplication.shared.getTopMostViewController() else {
            print("최상단 뷰 컨트롤러를 찾을 수 없습니다.")
            return
        }

        do {
            // 2. 이제 안전하게 이 VC 위에 광고를 띄웁니다.
            let reward = try await useCase.execute(from: topVC)
            print("보상 지급 성공: \(reward)")
            hasWatchedAd = true
            isOnLogo = false
        } catch {
            print("광고 표시 실패: \(error)")
        }
    }
}
