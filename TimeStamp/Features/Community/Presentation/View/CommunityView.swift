//
//  CommunityView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CommunityView: View {

    @StateObject private var viewModel: CommunityViewModel

    init(viewModel: CommunityViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            if viewModel.feeds.isEmpty && !viewModel.isLoading {
                emptyView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(viewModel.feeds, id: \.imageId) { feed in
                            CommunityCard(viewData: feed.toViewData())
                                .onAppear {
                                    // 마지막 아이템에 도달하면 다음 페이지 로드
                                    if feed.imageId == viewModel.feeds.last?.imageId {
                                        viewModel.loadMore()
                                    }
                                }
                                .onTapGesture {
                                    viewModel.toggleLike(imageId: feed.imageId)
                                }
                        }

                        // 로딩 인디케이터
                        if viewModel.isLoading {
                            ProgressView()
                                .padding()
                        }
                    }
                    .padding(.vertical, 10)
                }
                .refreshable {
                    viewModel.refresh()
                }
            }
        }
        .loading(viewModel.isLoading)
        .frame(maxHeight: .infinity)
        .mainBackgourndColor()
        .toast(message: $viewModel.toastMessage)
        .onAppear {
            if viewModel.feeds.isEmpty {
                viewModel.loadFeeds()
            }
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



