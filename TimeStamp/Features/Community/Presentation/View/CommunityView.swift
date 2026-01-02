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
        ZStack(alignment: .top) {
            if viewModel.feeds.isEmpty && !viewModel.isLoading {
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
        .loading(viewModel.isLoading && viewModel.feeds.isEmpty && !viewModel.isRefreshing)
        .toast(message: $viewModel.toastMessage)
        .onAppear {
            if viewModel.feeds.isEmpty {
                viewModel.loadFeeds()
            }
        }
    }
    
    private var feedListView: some View {
        List {
            ForEach(viewModel.feeds, id: \.imageId) { feed in
                CommunityCard(viewData: feed.toViewData())
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(.init(top: .zero, leading: 20, bottom: .zero, trailing: 20))
                    .onAppear {
                        // 마지막 아이템에 도달하면 다음 페이지 로드
                        if feed.imageId == viewModel.feeds.last?.imageId {
                            viewModel.loadMore()
                        }
                    }
            }

            // 하단 로딩 인디케이터 (더 불러오기)
            if viewModel.isLoading && !viewModel.feeds.isEmpty && !viewModel.isRefreshing {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
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



