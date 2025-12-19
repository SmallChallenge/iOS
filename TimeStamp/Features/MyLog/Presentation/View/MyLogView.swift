//
//  MyLogView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct MyLogView: View {
    @State private var selectedCategory: CategoryFilterViewData = .all
    @StateObject var viewModel: MyLogViewModel

    // 사진 간격
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]

    init(viewModel: MyLogViewModel){
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
            HeaderView()
            if viewModel.myLogs.isEmpty { // 내기록 없음
                MyLogEmptyView()

            } else { // 내 기록 있음.

                ScrollView {
                    VStack (spacing: .zero){
                        // 카테고리
                        CategoryView(selectedCategory: $selectedCategory)

                        // 사진 목록
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(Array(filteredLogs.enumerated()), id: \.element.id) { index, log in
                                PhotoCell(log: log)
                                    .aspectRatio(1, contentMode: .fill)
                                    .onAppear {
                                        if index == filteredLogs.count - 1 {
                                            //viewModel.loadMore()
                                        }
                                    }
                            }
                        }

                    }
                }
            }

        }
        .mainBackgourndColor()
        .loading(viewModel.isLoading)
        .onAppear {
            viewModel.loadLogs()
        }
        .onReceive(NotificationCenter.default.publisher(for: .didSavePhoto)) { _ in
            // 사진 저장 후 목록 새로고침
            viewModel.loadLogs()
        }
    }
}

#Preview {
    let localRepository = LocalTimeStampLogRepository()
    let repository = MyLogRepository(localRepository: localRepository)
    let useCase = MyLogUseCase(repository: repository)
    let viewModel = MyLogViewModel(useCase: useCase)
    return MyLogView(viewModel: viewModel)
}


