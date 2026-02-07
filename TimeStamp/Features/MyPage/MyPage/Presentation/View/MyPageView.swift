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
                        MyPageMenu("문의방법", type: .text(text: AppConstants.URLs.supportEmail)){}
                        
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
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onChange(of: viewModel.didLogout) { didLogout in
            if didLogout {
                onGoBack()
            }
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
    }
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
    
    private var thinLine: some View {
        Color.gray700
            .frame(height: 1)
    }
    private var thickLine: some View {
        Color.gray800
            .frame(height: 16)
    }
    
    // MARK: -
    
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
