//
//  MyLogView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct MyLogView: View {
    
    private let diContainer: MyLogDIContainerProtocol
    @StateObject private var viewModel: MyLogViewModel
    @ObservedObject private var authManager = AuthManager.shared
    @State private var selectedCategory: CategoryFilterViewData = .all
    @State private var selectedLog: TimeStampLogViewData?

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
                        
                        // 로컬 20개 제한 안내 팝업
                        if viewModel.localLogsCount >= AppConstants.Limits.warningLogCount // 18개 이상이면 뜬다
                            && !viewModel.isLogLimitBannerDismissed // 한번 닫으면 안뜬다.
                            && !authManager.isLoggedIn { // 로그아웃 상태일때만
                            LogLimitBannerView
                        }

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
//                        Spacer()
//                            .frame(height: 100)
                       
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
        }
        .navigationDestination(isPresented: Binding(
            get: { selectedLog != nil },
            set: { if !$0 { selectedLog = nil } }
        )) {
            if let log = selectedLog {
                diContainer.makeLogDetailView(log: log) {
                    selectedLog = nil
                }
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
                ProgressView(value: Double(viewModel.localLogsCount) / Double(AppConstants.Limits.maxLogCount) )
                    .progressViewStyle(.linear)
                    .tint(Color.neon300)

                // 로컬 기록 개수
                Text("\(viewModel.localLogsCount)/20")
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
            

        var bold = AttributedString("최대\(AppConstants.Limits.maxLogCount)개")
        bold.font = FontStyle.Caption_b.font
        result.append(bold)

        var rest = AttributedString("까지 남길 수 있습니다.")
        rest.font = FontStyle.Caption.font
        result.append(rest)

        return result
    }

}

#Preview {
    MockMyLogDIContainer().makeMyLogView()
}


