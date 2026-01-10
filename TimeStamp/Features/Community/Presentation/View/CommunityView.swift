//
//  CommunityView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CommunityView: View {

    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: CommunityViewModel
    @State private var showLoginPopup: Bool = false
    @State private var showLoginView: Bool = false
    @State private var showReportPopup: Bool = false
    @State private var selectedImageIdForReport: Int?

    init(viewModel: CommunityViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack(alignment: .top) {
            if viewModel.feedList.isEmpty && !viewModel.isLoading {
                emptyView
            } else {
                feedListView

                // 당겨서 새로고침 로딩 뷰
                if viewModel.isRefreshing {
                    HStack(spacing: 8) {
                        ProgressView()
                            .tint(.neon300)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 60)
                }
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
        // 로그인 팝업 띄우기
        .popup(isPresented: $showLoginPopup, content: {
            Modal(title: AppMessage.loginRequired.text)
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        showLoginPopup = false
                    }
                    MainButton(title: "로그인", colorType: .primary) {
                        // 로그인 화면 띄우기
                        showLoginPopup = false
                        showLoginView = true
                    }
                }
        })
        // 로그인 화면 띄우기
        .fullScreenCover(isPresented: $showLoginView, content: {
            AppDIContainer.shared.makeLoginView {
                showLoginView = false
            }
        })
        // 신고할지 팝업으로 물어보기
        .popup(isPresented: $showReportPopup) {
            Modal(title: "부적절한 게시물인가요?")
                .buttons {
                    MainButton(title: "취소", colorType: .secondary) {
                        showReportPopup = false
                        selectedImageIdForReport = nil
                    }
                    MainButton(title: "신고", colorType: .primary) {
                        if let imageId = selectedImageIdForReport {
                            viewModel.report(imageId: imageId)
                        }
                        showReportPopup = false
                        selectedImageIdForReport = nil
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
                                showLoginPopup = true
                                return
                            }
                            // 신고할 imageId 저장하고 팝업 띄우기
                            selectedImageIdForReport = feedViewData.imageId
                            showReportPopup = true
                        }, onLike: {
                            // 좋아요 누름
                            guard authManager.isLoggedIn else {
                                showLoginPopup = true
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
                    CommunityBannerView(viewData: bannerData)
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
}

#Preview {
    // Preview용 Mock ViewModel 필요
    MockCommunityDiContainer().makeCommunityView()
}



