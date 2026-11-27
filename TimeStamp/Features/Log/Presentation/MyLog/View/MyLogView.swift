//
//  MyLogView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct MyLogView: View {

    @StateObject private var viewModel: MyLogViewModel
    @Binding var selectedLog: TimeStampLogViewData?

    // 사진 간격
    private let columns = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1)
    ]
    
    // 최초 데이터 로드 여부
    @State private var hasLoadedInitialData: Bool = false

    init(viewModel: MyLogViewModel, selectedLog: Binding<TimeStampLogViewData?>){
        _viewModel = StateObject(wrappedValue: viewModel)
        _selectedLog = selectedLog
    }

    var body: some View {
        VStack(spacing: .zero) {
                ScrollView {
                    VStack (spacing: .zero){
                        
                        // - 카테고리 탭 - //
                        CategoryView(
                            selectedCategory: viewModel.selectedCategory,
                            availableCategories: CategoryFilterViewData.allCases
                        ){ category in
                            viewModel.selectCategory(category)
                        }
                        
                        // - 로컬 20개 제한 안내 팝업 - //
                        if viewModel.shouldShowLogLimitBanner {
                            LogLimitBannerView
                        }

                        // - 사진 목록 - //
                        if viewModel.myLogs.isEmpty {
                            // 해당 카테고리 해당되는 사진 없음
                            MyLogEmptyView()
                                .frame(minHeight: viewModel.emptyViewHeight)
                                                        
                        } else {
                            // 해당 카테고리 해당되는 사진 있음
                            LazyVGrid(columns: columns, spacing: 1) {
                                ForEach(Array(viewModel.myLogs.enumerated()), id: \.element.id) { index, log in
                                    Button(action: {
                                        selectedLog = log
                                    }, label: {
                                        PhotoCell(log: log)
                                            .aspectRatio(1, contentMode: .fill)
                                    })
                                    .id(log.id)
                                    .onAppear { // 페이징
                                        if index == viewModel.myLogs.count - 1 {
                                            viewModel.loadMore()
                                        }
                                    }
                                }
                            }
                        }
                        
                        Color.clear
                            .frame(height: 58)
                       
                        // 추가 로딩 인디케이터
                        if viewModel.isLoadingMore {
                             ProgressView()
                                 .tint(.neon300)
                                 .frame(maxWidth: .infinity)
                                 .padding()
                             
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
        }
        .mainBackgourndColor()
        .loading(viewModel.isLoading)
        .task {
            if !hasLoadedInitialData {
                // 최초 한번만 목록 불러오기
                viewModel.refreshLogs()
                hasLoadedInitialData = true
            }
            viewModel.updateLocalLogsCount()
        }
        .onReceive(NotificationCenter.default.publisher(for: .shouldRefreshMyLog)) { _ in
            // 로그인 , 사진 저장 후 목록 새로고침
            viewModel.selectCategory(.all)
        }
        .onReceive(NotificationCenter.default.publisher(for: .hideLog)) { notification in
            guard let logUUId = notification.userInfo?["logId"] as? UUID else {
                return
            }
            viewModel.hideLog(uuid: logUUId)
        }
        
        .toast(message: $viewModel.toastMessage)
    }
    
    private var LogLimitBannerView: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10){
                Text(guestLimitText)
                    .foregroundStyle(Color.gray200)
                Spacer()
                
                Button {
                    // 배너닫기
                    viewModel.dismissLogLimitBanner()
                } label: {
                    Image("close_line")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.gray300)
                }
            }
            
            // 20개 제한 안내 배너
            HStack(spacing: 8){
                //progress bar
                ProgressView(value: Double(viewModel.localLogsCount) / Double(LogPolicy.maxLogCount) )
                    .progressViewStyle(.linear)
                    .tint(Color.neon300)

                // 로컬 기록 개수
                Text("\(viewModel.localLogsCount)/\(LogPolicy.maxLogCount)")
                    .font(.Caption)
                    .foregroundStyle(Color.gray500)
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.gray700)
    }
    
    // 게스트 제한 안내 텍스트 (부분별 폰트 적용)
    private var guestLimitText: AttributedString {
        var result = AttributedString("게스트는 기록을 ")
        result.font = FontStyle.Caption.font
            

        var bold = AttributedString("최대\(LogPolicy.maxLogCount)개")
        bold.font = FontStyle.Caption_b.font
        result.append(bold)

        var rest = AttributedString("까지 남길 수 있습니다.")
        rest.font = FontStyle.Caption.font
        result.append(rest)

        return result
    }
}

#Preview {
    MockMyLogDIContainer().makeMyLogView(selectedLog: .constant(TimeStampLogViewData(
        id: UUID(),
        category: .food,
        timeStamp: Date.now,
        imageSource: .remote(TimeStampLog.RemoteTimeStampImage(
            id: 0,
            imageUrl: "https://picsum.photos/400/400"
        )),
        visibility: .privateVisible
    )))
}


