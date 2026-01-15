//
//  CommunityView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CommunityView: View {

    enum PopupType {
        case login
        case report(imageId: Int)
        case block(nickname: String)
    }

    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: CommunityViewModel
    @State private var activePopup: PopupType?
    @State private var showLoginView: Bool = false
    @Binding var triggerRefresh: Bool

    init(viewModel: CommunityViewModel, triggerRefresh: Binding<Bool> = .constant(false)) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _triggerRefresh = triggerRefresh
    }

    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.feedList.isEmpty && !viewModel.isLoading {
                emptyView
            } else {
                feedListView
            }
        } // ~ZStack
        .mainBackgourndColor()
        .loading(viewModel.isLoading && !viewModel.isRefreshing)
        .toast(message: $viewModel.toastMessage)
        .onAppear {
            if viewModel.feedList.isEmpty {
                viewModel.loadFeeds()
            }
            // 앰플리튜드
            AmplitudeManager.shared.trackCommunityViewEnter()
        }
        // 팝업 통합 관리
        .popup(isPresented: Binding(
            get: { activePopup != nil },
            set: { if !$0 { activePopup = nil } }
        )) {
            popupContentView
        }
        // 로그인 화면 띄우기
        .fullScreenCover(isPresented: $showLoginView, content: {
            AppDIContainer.shared.makeLoginView {
                showLoginView = false
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .shouldRefresh)) { _ in
            // 로그인 후 목록 새로고침
            viewModel.loadFeeds(isRefresh: true)
        }
        .onChange(of: triggerRefresh) { shouldRefresh in
            if shouldRefresh {
                // 프로그래밍 방식으로 refresh 트리거
                Task {
                    await triggerProgrammaticRefresh()
                    triggerRefresh = false
                }
            }
        }
    }
    
    private var feedListView: some View {
        List {
            ForEach(viewModel.communityListItems) { item in
                switch item {
                case .feed(let feedViewData):
                    CommunityCard(
                        viewData: feedViewData,
                        isMenuOpen: Binding(
                            get: { viewModel.selectedFeedIdForMenu == feedViewData.imageId },
                            set: { isOpen in
                                if isOpen {
                                    viewModel.selectFeedForMenu(id: feedViewData.imageId)
                                } else {
                                    viewModel.selectFeedForMenu(id: nil)
                                }
                            }
                        ),
                        onReport: {
                            guard authManager.isLoggedIn else {
                                activePopup = .login
                                return
                            }
                            activePopup = .report(imageId: feedViewData.imageId)
                        }, onBlock: {
                            guard authManager.isLoggedIn else {
                                activePopup = .login
                                return
                            }
                            activePopup = .block(nickname: feedViewData.nickname)
                        }, onLike: {
                            guard authManager.isLoggedIn else {
                                activePopup = .login
                                return
                            }
                            viewModel.toggleLike(imageId: feedViewData.imageId)
                        }
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: .zero, leading: 20, bottom: .zero, trailing: .zero))
                    .onAppear {
                        // 마지막 피드에 도달하면 다음 페이지 로드
                        if feedViewData.imageId == viewModel.feedList.last?.imageId {
                            viewModel.loadMore()
                        }
                    }

                case .banner(let bannerData):
                    CommunityBannerView(viewData: bannerData,
                                        loginAction: {
                        activePopup = .login
                    })
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(.init(top: 8, leading: 20, bottom: 8, trailing: 20))
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .refreshable {
            await viewModel.refresh()
        }
    }

    @ViewBuilder
    private var popupContentView: some View {
        switch activePopup {
        case .login:
            Modal(title: AppMessage.loginRequired.text)
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        activePopup = nil
                    }
                    MainButton(title: "로그인", colorType: .primary) {
                        activePopup = nil
                        showLoginView = true
                    }
                }
        case .report(let imageId):
            Modal(title: "부적절한 게시물인가요?")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        activePopup = nil
                    }
                    MainButton(title: "신고", colorType: .primary) {
                        viewModel.report(imageId: imageId)
                        activePopup = nil
                    }
                }
        case .block(let nickname):
            Modal(title: "[\(nickname)]님을 차단하시겠습니까?",
                  content: "차단하면 이 사용자의 게시물이\n더 이상 표시되지 않습니다.")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        activePopup = nil
                    }
                    MainButton(title: "차단", colorType: .primary) {
                        viewModel.block(nickname: nickname)
                        activePopup = nil
                    }
                }
        case .none:
            EmptyView()
        }
    }

    private var emptyView: some View {
        VStack(alignment: .center, spacing: 20) {
            Image("img_cm_empty")
                .resizable()
                .frame(width: 140, height: 140)

            VStack(alignment: .center, spacing: 8) {
                Text("아직은 우리만의 비밀 공간 같아요.")
                    .font(.Body1)
                    .foregroundStyle(Color.gray500)

                Text("첫 게시물로 문을 열어주세요.")
                    .font(.Body1)
                    .foregroundStyle(Color.gray500)
            }
        }
    }

    // MARK: - Programmatic Refresh


    /// 프로그래밍 방식으로 pull-to-refresh 트리거
    @MainActor
    private func triggerProgrammaticRefresh() async {
        // UIScrollView 찾기
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let scrollView = findScrollView(in: window) else {
            // ScrollView를 찾지 못하면 직접 refresh만 호출
            await viewModel.refresh()
            return
        }

        // 1. 먼저 맨 위로 스크롤 (네비게이션 바 고려)
        let targetY = -scrollView.adjustedContentInset.top

        // UIView.animate로 직접 애니메이션
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentOffset = CGPoint(x: 0, y: targetY)
            }, completion: { _ in
                continuation.resume()
            })
        }

        // 3. refresh control 시작 (있으면)
        if let refreshControl = scrollView.refreshControl {
            // 색상이 확실히 적용되도록 직접 설정
            refreshControl.tintColor = UIColor(Color.neon300)
            
            refreshControl.beginRefreshing()
            // refresh control이 보이도록 약간 아래로
            scrollView.setContentOffset(CGPoint(x: 0, y: -200), animated: true)
        }

        // 4. 실제 새로고침 실행
        await viewModel.refresh()

        // 5. refresh control 종료
        scrollView.refreshControl?.endRefreshing()
    }

    /// 뷰 계층에서 UIScrollView 찾기
    private func findScrollView(in view: UIView) -> UIScrollView? {
        if let scrollView = view as? UIScrollView {
            return scrollView
        }

        for subview in view.subviews {
            if let scrollView = findScrollView(in: subview) {
                return scrollView
            }
        }

        return nil
    }
}

#Preview {
    // Preview용 Mock ViewModel 필요
    MockCommunityDiContainer().makeCommunityView()
}



