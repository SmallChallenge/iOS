//
//  MyLogView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct MyLogView: View {
    @State private var selectedCategory: CategoryFilterViewData = .all
    @State private var selectedLog: TimeStampLogViewData?
    @StateObject private var viewModel: MyLogViewModel
    private let diContainer: MyLogDIContainerProtocol

    

    // 사진 간격
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    init(viewModel: MyLogViewModel, diContainer: MyLogDIContainerProtocol){
        self.diContainer = diContainer
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    /// 선택된 카테고리로 필터링된 로그
    private var filteredLogs: [TimeStampLogViewData] {
        if selectedCategory == .all {
            return viewModel.myLogs
        } else {
            return viewModel.myLogs.filter { log in
                switch selectedCategory {
                case .all: return true
                case .study: return log.category == .study
                case .health: return log.category == .health
                case .food: return log.category == .food
                case .etc: return log.category == .etc
                }
            }
        }
    }

    var body: some View {
        VStack {
            if viewModel.myLogs.isEmpty { // 내기록 없음
                MyLogEmptyView()

            } else { // 내 기록 있음.

                ScrollView {
                    VStack (spacing: .zero){
                        // 카테고리
                        CategoryView(
                            selectedCategory: $selectedCategory,
                            availableCategories: viewModel.availableCategories
                        )

                        // 사진 목록
                        LazyVGrid(columns: columns, spacing: 1) {
                            ForEach(Array(filteredLogs.enumerated()), id: \.element.id) { index, log in
                                Button(action: {
                                    selectedLog = log
                                }, label: {
                                    PhotoCell(log: log)
                                        .aspectRatio(1, contentMode: .fill)
                                })
                                .onAppear {
                                    if index == filteredLogs.count - 1 {
                                        viewModel.loadMore()
                                    }
                                }
                            }
                        }
                       
                        // 추가 로딩 인디케이터
                        if viewModel.isLoadingMore {
                            
                             ProgressView()
                                 .tint(.neon300)
                                 .frame(maxWidth: .infinity)
                                 .padding()
                             
                        }

                    }
                }
                .background(
                    NavigationLink(
                        destination: Group {
                            if let log = selectedLog {
                                diContainer.makeLogDetailView(log: log) {
                                    selectedLog = nil
                                }
                            }
                        },
                        isActive: Binding(
                            get: { selectedLog != nil },
                            set: { if !$0 { selectedLog = nil } }
                        )
                    ) {
                        EmptyView()
                    }
                )
            }
        }
        .mainBackgourndColor()
        .loading(viewModel.isLoading)
        .onAppear {
            viewModel.loadLogs()
        }
        .onReceive(NotificationCenter.default.publisher(for: .shouldRefreshMyLog)) { _ in
            // 사진 저장 또는 로그인 후 목록 새로고침
            viewModel.loadLogs()
        }
        .toast(message: $viewModel.toastMessage)
    }
}

#Preview {
    let diContainer = MockMyLogDIContainer()
    diContainer.makeMyLogView()
}


