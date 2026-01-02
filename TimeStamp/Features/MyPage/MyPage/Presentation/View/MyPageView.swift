//
//  MyPageView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import SwiftUI
import UIKit

/// 마이페이지 화면
struct MyPageView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: MyPageViewModel
    private let appDiContainer = AppDIContainer.shared
    private let diContainer: MyPageDIContainerProtocol
    
    
    @State var showLoginView: Bool = false
    @State var presentUserInfo: Bool = false
    
    init(viewModel: MyPageViewModel, diContainer: MyPageDIContainerProtocol){
        _viewModel = StateObject(wrappedValue: viewModel)
        self.diContainer = diContainer
    }
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 30) {
                if authManager.isLoggedIn {
                    
                    Button {
                        presentUserInfo = true
                    } label: {
                        Text("내 정보")
                    }

                    Button("로그아웃"){
                        viewModel.logout()
                    }
                    
                    Button("토큰복사"){
                        copyTokenForTest()
                    }
                    
                } else {
                    Button("로그인") {
                        showLoginView = true
                    }
                }
                
                
                Button("로그 공유 (\(Logger.getLogCount())개)"){
                    shareLog()
                }

            }
        }
        .navigationDestination(isPresented: $presentUserInfo) {
            diContainer.makeUserInfoPageView { needRefresh in
                print(">>>>> needRefresh \(needRefresh)")
                presentUserInfo = false
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            appDiContainer.makeLoginView {
                showLoginView = false
            }
        }

    }
    
    private func copyTokenForTest(){
        guard let token = authManager.getAccessToken() else {
            ToastManager.shared.show("토큰이 없습니다")
            return
        }

        // 클립보드에 복사
        UIPasteboard.general.string = token

        // 복사 완료 토스트
        ToastManager.shared.show("토큰이 복사되었습니다")
    }

    private func shareLog() {
        print(">>> shareLog 호출됨")
        print(">>> 현재 로그 개수: \(Logger.getLogCount())")

        // 로그 파일 생성
        guard let fileURL = Logger.exportLogsToFile() else {
            print(">>> 로그 파일 생성 실패")
            ToastManager.shared.show("공유할 로그가 없습니다")
            return
        }

        print(">>> 로그 파일 생성 성공: \(fileURL.path)")

        // UIKit 방식으로 직접 공유 시트 띄우기
        let activityVC = UIActivityViewController(
            activityItems: [fileURL],
            applicationActivities: nil
        )

        // iPad 지원
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {

            // 현재 presented 된 VC 찾기
            var topVC = rootVC
            while let presentedVC = topVC.presentedViewController {
                topVC = presentedVC
            }

            // iPad에서 popover 설정
            if let popover = activityVC.popoverPresentationController {
                popover.sourceView = topVC.view
                popover.sourceRect = CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
                popover.permittedArrowDirections = []
            }

            topVC.present(activityVC, animated: true)
            print(">>> 공유 시트 표시 완료")
        }

        //Logger.info("로그 파일 공유 준비 완료: \(fileURL.lastPathComponent)")
    }
}

#Preview {
    MockMyPageDIContainer().makeMyPageView()
}
