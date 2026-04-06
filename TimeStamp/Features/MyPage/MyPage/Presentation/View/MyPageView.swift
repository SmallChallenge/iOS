//
//  MyPageView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/24/25.
//

import SwiftUI
import UIKit
import MessageUI

/// 마이페이지 화면
struct MyPageView: View {
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: MyPageViewModel
    let onGoBack: () -> Void
    
    private let appDiContainer = AppDIContainer.shared
    private let diContainer: MyPageDIContainerProtocol
    
    @State var showLoginView: Bool = false
    @State var presentUserInfo: Bool = false
    @State var showLogoutPopup: Bool = false
    
    /// 이용약관 띄우기(웹뷰)
    @State private var showTermsOfService: Bool = false
    
    /// 개인정보처리방침  띄우기(웹뷰)
    @State private var showPrivacyPolicy: Bool = false
    
    /// 오픈소스라이선스(웹뷰)띄우기
    @State private var showOpenSourceLicense: Bool = false
    
    /// 문의 메일 보내기 띄우기
    @State private var isShowingMailView = false
    
    private let appVersion: String
    
    init(viewModel: MyPageViewModel,
         diContainer: MyPageDIContainerProtocol,
         onGoBack: @escaping () -> Void
    ){
        _viewModel = StateObject(wrappedValue: viewModel)
        self.diContainer = diContainer
        self.onGoBack = onGoBack

        // 앱 버전 정보 가져오기
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        self.appVersion = "\(version)(\(build))"

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.gray900
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: .zero) {
                    
                    //thinLine
                    Spacer()
                        .frame(height: 24)
                    
                    if authManager.isLoggedIn {
                        Button {
                            presentUserInfo = true
                        } label: {
                            userProfile
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 24)
                        
                    } else {
                        guestProfile
                            .padding(.top, 20)
                            .padding(.bottom, 24)
                        
                        // 로그인 유도 배너, 로그인 버튼
                        VStack(spacing: 16){
                            loginPromptBannerView
                            
                            MainButton(title: "로그인") {
                                showLoginView = true
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 32)
                        .padding(.horizontal, 20)
                        
                    }
                    thickLine
                    
                    // 메뉴버튼
                    VStack(spacing: .zero) {
                        
                        // 갤러리에 자동 저장
                        authSaveMenu
                        
                        thickLine
                        
                        MyPageMenu("이용약관", type: .chevron){
                            showTermsOfService = true
                        }
                        MyPageMenu("개인정보 처리방침", type: .chevron){
                            showPrivacyPolicy = true
                        }
                        MyPageMenu("오픈소스 라이센스", type: .chevron){
                            showOpenSourceLicense = true
                        }
                        MyPageMenu("앱 버전", type: .text(text: appVersion)){}
                        MyPageMenu("문의하기", type: .none){
                           sendEmail()
                        }
                        
                        if authManager.isLoggedIn {
                            MyPageMenu("로그아웃", type: .none){
                                showLogoutPopup = true
                            }
                        }
                    }
                    
                    #if DEBUG
                    Button("토큰복사"){
                        copyTokenForTest()
                    }
                    Button("로그 공유 (\(Logger.getLogCount())개)"){
                        shareLog()
                    }
                    
                    Spacer()
                        .frame(height: 100)
                    #endif
                    
                    Spacer()
                   
                }
            } // ~ScrollView
            .safeAreaInset(edge: .top) {
                HeaderView(leadingView: {
                    BackButton {
                        onGoBack()
                    }
                }, title: "마이페이지", hasUnderLine: true)
                .background(Color.gray900)
            }
            
            
            // 하단 배너 광고
            BannerAd()
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding(.horizontal, 30)
                .ignoresSafeArea(edges: .bottom)
            
            
        } //~ ZStack
        .mainBackgourndColor()
        .task {
            viewModel.getAutoSave()
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.didLogout) { didLogout in
            if didLogout {
                onGoBack()
            }
        }
        .onChange(of: viewModel.isAutoSave) { isAutoSave in
            viewModel.updateAutoSave(isAutoSave)
        }
        // 유저정보화면 띄우기
        .navigationDestination(isPresented: $presentUserInfo) {
            diContainer.makeUserInfoPageView(onGoBack: {
                presentUserInfo = false
            }, onSignOutCompleted: {
                // 회원탈퇴 완료 시 메인으로 복귀
                presentUserInfo = false
                onGoBack()
            })
        }
        // 로그인화면띄우기
        .fullScreenCover(isPresented: $showLoginView) {
            appDiContainer.makeLoginView {
                showLoginView = false
            }
        }
        // 로그아웃 팝업띄우기
        .popup(isPresented: $showLogoutPopup) {
            Modal(title: "로그아웃하시겠습니까?", content: "로그아웃 후 작성한 기록은 백업되지 않으며, 비로그인 상태 기록은 최대 20개로 제한됩니다.")
                .buttons {
                    MainButton(title: "취소" , size: .middle, colorType: .secondary){
                        showLogoutPopup = false
                    }
                    MainButton(title: "로그아웃" , size: .middle, colorType: .primary){
                        viewModel.logout()
                        showLogoutPopup = false
                    }
                }
        }
        // 이용약관(웹뷰)
        .sheet(isPresented: $showTermsOfService) {
            appDiContainer.makeWebView(url: AppConstants.URLs.termsOfService) {
                showTermsOfService = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        // 개인정보처리방침(웹뷰)
        .sheet(isPresented: $showPrivacyPolicy) {
            appDiContainer.makeWebView(url: AppConstants.URLs.privacyPolicy) {
                showPrivacyPolicy = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        // 오픈소스라이선스(웹뷰)
        .sheet(isPresented: $showOpenSourceLicense) {
            appDiContainer.makeWebView(url: AppConstants.URLs.openSourceLicense) {
                showOpenSourceLicense = false
            }
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
        // 문의 메일 보내기
        .sheet(isPresented: $isShowingMailView) {
            MailView(userId: "\(authManager.currentUser?.userId ?? -1)")
        }
        .toast(message: $viewModel.toastMessage)
    }
    
    // MARK: -
    
    private var userProfile: some View {
        HStack(alignment: .center,spacing: 16) {
            Image("profile")
                .resizable()
                .frame(width: 60, height: 60)
            
            VStack (alignment: .leading, spacing: 4){
                Text(authManager.currentUser?.nickname ?? "")
                    .font(.H3)
                    .foregroundStyle(Color.gray50)
                
            }
            Spacer()
            
            ChevronRight()
                .foregroundStyle(Color.gray50)
            
        }
        .padding(.leading, 20)
        .padding(.trailing, 12)
    }
    
    private var guestProfile: some View {
        HStack(alignment: .center,spacing: 16) {
            Image("profile")
                .resizable()
                .frame(width: 60, height: 60)
            
            VStack (alignment: .leading, spacing: 4){
                Text("게스트")
                    .font(.H3)
                    .foregroundStyle(Color.gray50)
                
                Text("기록 일부 제한")
                    .font(.Caption)
                    .foregroundStyle(Color.gray500)
            }
            Spacer()
        }
        .padding(.leading, 20)
        .padding(.trailing, 12)
    }
    
    
    private var loginPromptBannerView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("로그인하고 기록을 계속 이어가세요 ✨")
                .font(.SubTitle2)
                .foregroundStyle(Color.gray50)
            
            VStack (alignment: .leading, spacing: 12){
                //자동 백업 및 무제한 기록
                HStack {
                    Text("✓")
                        .font(.Body2)
                        .foregroundStyle(Color.neon300)
                    
                    Text("자동 백업 및 무제한 기록")
                        .font(.SubTitle2)
                    
                    Spacer()
                }
                
                HStack {
                    Text("✓")
                        .font(.Body2)
                        .foregroundStyle(Color.neon300)
                    
                    Text("기록 ")
                        .font(FontStyle.Body2.font)
                    + Text("전체공개 ")
                        .font(FontStyle.SubTitle2.font)
                    + Text("설정 가능")
                        .font(FontStyle.Body2.font)
                    
                    Spacer()
                }
                
                HStack(spacing: 8) {
                    Image(systemName: "info.circle.fill")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("게스트 기록은 이후에도 백업·공개가 불가해요.")
                        .font(.Caption)
                    
                    Spacer()
                }
                .foregroundStyle(Color.gray500)
                
            }

            .foregroundStyle(Color.gray50)
            
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 24)
        .background(Color.gray800)
        .rounded(radius: 16)
    }
    
    // 자동저장 메뉴
    private var authSaveMenu: some View {
        VStack(alignment: .leading, spacing: .zero) {
            Text("카메라 설정")
                .font(.Label)
                .foregroundStyle(Color.gray500)
                .padding([.top, .leading], 20)
            
            HStack {
                Text("갤러리에 자동 저장")
                    .font(.Btn2_b)
                    .foregroundStyle(Color.gray300)
                
                Spacer()
                
                Toggle(isOn: $viewModel.isAutoSave) {}
                .padding(.trailing, 20)
                
            }
            .padding(.leading, 20)
            .padding(.vertical, 19.5)

        }
        
    }
    
    private var thinLine: some View {
        Color.gray700
            .frame(height: 1)
    }
    private var thickLine: some View {
        Color.gray800
            .frame(height: 16)
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
    func copyToClipboard(recipient: String) {
        UIPasteboard.general.string = recipient
        viewModel.toastMessage = "클립보드에 복사되었습니다."
        Logger.success("이메일 주소 클립보드 복사 완료")
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
    MockMyPageDIContainer().makeMyPageView(onGoBack: {})
}
