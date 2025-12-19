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
                            ForEach(Array(viewModel.myLogs.enumerated()), id: \.element.id) { index, log in
                                PhotoCell(log: log)
                                    .aspectRatio(1, contentMode: .fill)
                                    .onAppear {
                                        if index == viewModel.myLogs.count - 1 {
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
    }
}

#Preview {
    MyLogView(viewModel: MyLogViewModel())
}


