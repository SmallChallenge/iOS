//
//  MainView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import Foundation
import SwiftUI
import AVFoundation
import MessageUI

struct MainTabView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: MainTabViewModel
    private let container: AppDIContainer
    
    
    @State private var selectedTab: Int = 0
    @State private var showCamera: Bool = false
    @State private var presentMypage: Bool = false
    @State private var selectedLog: TimeStampLogViewData? = nil

    
    @State private var showLoginView: Bool = false
    @State private var showLimitReachedPopup: Bool = false
    
    /// 문의 메일 보내기 띄우기
    @State private var isShowingMailView = false

    @State private var triggerCommunityRefresh: Bool = false
    
    
    init(container: AppDIContainer, viewModel: MainTabViewModel) {
        self.container = container
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack (spacing: .zero) {
                // 커스텀 헤더
                MainHeaderView(selectedTab: $selectedTab) {
                        presentMypage = true
                    }
                
                // content화면 (내기록 | 커뮤니티)
                TabView (selection: $selectedTab){
                    
                    // 내기록
                    container.makeMyLogView(selectedLog: $selectedLog)
                        .tag(0)
                    
                    EmptyView()
                        .tag(1)
                    
                    // 커뮤니티 화면
                    container.makeCommunityView(
                        triggerRefresh: $triggerCommunityRefresh,
                        onOpenCamera: {
                            showCamera = true
                        }
                    )
                    .tag(2)
                    
                } //~TabView
                .hideTabBar()
                
                // 커스텀 탭바 [내 기록 | 촬영버튼 | 커뮤니티]
                MainTabBar(
                    selectedTab: $selectedTab,
                    onCameraButtonTapped: {
                        // 로컬기록이 20개 이상이면 팝업 띄우기
                        if viewModel.canTakePhoto() {
                            showCamera = true
                        } else {
                            // 한계도달 팝업 띄우기
                            showLimitReachedPopup = true
                            AmplitudeManager.shared.trackPhotoLimitReached()
                        }
                    },
                    onCommunityReselected: {
                        // 커뮤니티 탭 재선택 시 새로고침 트리거
                        triggerCommunityRefresh = true
                    }
                )
                
            } // ~ VStack
            .navigationBarHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .mainBackgourndColor()
            .toast(message: $viewModel.toastMessage)
            .task {
                // 추적 권한 요청
                await viewModel.requestAuthorization()
            }
            .popup(isPresented: $showLimitReachedPopup, content: {
                Modal(title: AppMessage.maxPhotoLimitReached.text)
                    .buttons {
                        MainButton(title: "취소", colorType: .secondary) {
                            showLimitReachedPopup = false
                        }
                        MainButton(title: "로그인") {
                            showLoginView = true
                            showLimitReachedPopup = false
                        }
                    }
            })
            .popup(isPresented: $viewModel.showReviewPopup, content: {
                reviewPopup
            })
            .onReceive(NotificationCenter.default.publisher(for: .didSaveLog), perform: { _ in
                // 사진 저장 후 탭바 '내기록'으로 이동
                selectedTab = 0
                
                // 리뷰 띄울지 확인하기
                viewModel.checkShowReviewPopup()
            })
            // 마이페이지 화면으로
            .navigationDestination(isPresented: $presentMypage) {
                container.makeMyPageView(onGoBack: {
                    presentMypage = false
                })
            }
            // 기록 상세보기 화면으로
            .navigationDestination(isPresented: Binding(
                get: { selectedLog != nil },
                set: { if !$0 { selectedLog = nil } }
            )) {
                if let log = selectedLog {
                    container.makeLogDetailView(log: log) {
                        selectedLog = nil
                    }
                }
            }
            // 카메라 촬영화면 띄우기
            .fullScreenCover(isPresented: $showCamera) {
                container.makeCameraTapView  {
                    showCamera = false
                }
            }
            // 로그인 화면 띄우기
            .fullScreenCover(isPresented: $showLoginView) {
                container.makeLoginView {
                    showLoginView = false
                }
            }
            // 문의 메일 보내기
            .sheet(isPresented: $isShowingMailView) {
                MailView(userId: "\(authManager.currentUser?.userId ?? -1)")
            }
            
        } // ~NavigationStack
    }
    
    private var reviewPopup: some View {
        ReviewPopup(
            didTapReviewButton: {
                // 인앱리뷰 띄우기
                StoreRatingsManager().requestRatings()
                viewModel.dismissReviewPopup()
                
                // 122일 뒤에 띄우기 (1년에 3번 띄울 수 있으니까)
                viewModel.delayReviewPopup(day: 122)
            },
            didTapFeedbackButton: {
                // 메일로 문의하기 보내기
                sendEmail()
                viewModel.dismissReviewPopup()
                
                // 90일 뒤에 띄우기
                viewModel.delayReviewPopup(day: 90)
            },
            didTapDismissButton: {
                // 나중에 할게요
                viewModel.dismissReviewPopup()
                // 30일 뒤에 띄우기
                viewModel.delayReviewPopup(day: 30)
            }
        )
    }
    
    // MARK: -
    
    private func sendEmail() {
        let recipient = AppConstants.URLs.supportEmail
        let userId = "\(authManager.currentUser?.userId ?? -1)"
        let emailBody = EmailHelper.getSupportEmailBody(userId: userId)
        let subject = "[스탬픽] 서비스 문의"
        
        // 1단계: 아이폰 기본 Mail 앱 + 계정 설정이 되어 있는 경우
        if MFMailComposeViewController.canSendMail() {
            self.isShowingMailView = true
            Logger.success("이메일 전송1")
            return // 실행 후 종료
        }
        
        // 2단계: (기본 앱은 없지만) 다른 메일 앱(Gmail, Outlook 등)이라도 있는 경우
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let encodedBody = emailBody.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let mailtoUrlString = "mailto:\(recipient)?subject=\(encodedSubject)&body=\(encodedBody)"

        if let url = URL(string: mailtoUrlString) {
            // 1. 일단 열 수 있는지 확인
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        Logger.success("이메일 전송2 성공")
                    } else {
                        // [핵심] 열 수 있다고 했는데 실제 실행에 실패한 경우 (에러 115 방어)
                        Logger.error("이메일 앱 실행 실패 - 복사 로직으로 이동")
                        self.copyToClipboard(recipient: recipient)
                    }
                }
                return
            }
            // 2. 아예 열 수 있는 앱이 없는 경우
            else {
                self.copyToClipboard(recipient: recipient)
                return
            }
        }
    }
    
    // 메일 클립보드 복사
    private func copyToClipboard(recipient: String) {
        UIPasteboard.general.string = recipient
        viewModel.toastMessage = "메일 주소가 복사되었습니다.\n문의 메일을 보내주세요."
        Logger.success("이메일 주소 클립보드 복사 완료")
    }

}

#Preview {
    AppDIContainer.shared.makeMainTabView()
}
