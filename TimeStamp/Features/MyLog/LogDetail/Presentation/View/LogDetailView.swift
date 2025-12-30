//
//  LogDetailView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/30/25.
//

import SwiftUI
import Kingfisher
import Photos

/// 기록 상세 보기 화면
struct LogDetailView: View {
    
    @ObservedObject private var authManager = AuthManager.shared
    @StateObject private var viewModel: LogDetailViewModel
    let onGoBack: (() -> Void)
    init(viewModel: LogDetailViewModel, onGoBack: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onGoBack = onGoBack
    }
    
    @State private var showDeletePopup: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Group {
                    // 메뉴버튼 + 이미지뷰
                    VStack(spacing: 16) {
                        HStack {
                            Spacer()
                            Button {
                                // TODO: 팝메뉴 띄우기
                            } label: {
                                ellipsisImage
                            }
                        }
                        
                        // 이미지 뷰
                        logImage
                    }
                    
                    // 카테고리 + 공개여부
                    HStack(spacing: 20) {
                        // 카테고리
                        category
                        
                        // 공개 여부
                        visibility
                        Spacer()
                    }
                    
                    if !authManager.isLoggedIn {
                        // 로그인 안내 배너
                        LoginRequiredBanner
                    }
                    
                    // 공유하기 버튼
                    MainButton(title: "공유하기", colorType: .secondary) {
                        // TODO: 공유하기
                        showDeletePopup = true
                    }
                } // ~Group
                .padding(.horizontal, 20)
            } //~VStack
        } //~ScrollView
        .mainBackgourndColor()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            // 뒤로가기 버튼
            ToolbarItem(placement: .navigationBarLeading) {
                BackButton {
                    onGoBack()
                }
            }
        }
        .popup(isPresented: $showDeletePopup) {
            Modal(title: "사진을 삭제하시겠습니까?")
                .buttons {
                    MainButton(title: "취소", size: .middle) {
                        showDeletePopup = false
                    }
                    MainButton(title: "삭제", size: .middle) {
                        showDeletePopup = false
                        viewModel.deleteLog()
                    }
                }
        }
    }
    
    private var ellipsisImage: some View {
        Image(systemName: "ellipsis")
            .foregroundStyle(Color.gray50)
            .padding(.vertical, 10.11)
            .padding(.horizontal, 2.53)
    }
    
    private var logImage: some View {
        Group {
            switch viewModel.log.imageSource {

                // MARK: 서버이미지
            case let .remote(remoteImage):
                
                KFImage(URL(string: remoteImage.imageUrl))
                    .placeholder {
                        Placeholder()
                    }
                    .retry(maxCount: 3, interval: .seconds(2))
                    .cacheMemoryOnly()
                    .onFailure { error in
                        Logger.error("Image load failed: \(error.localizedDescription)")
                    }
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFill()

                // MARK: 로컬 이미지
            case let .local(localImage):
                LocalImageView(imageFileName: localImage.imageFileName)
                
            } //~switch
        }
        .clipped()
//        .aspectRatio(1, contentMode: .fit)
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .roundedBorder(color: .gray700, radius: 8)
    }
    
    private var LoginRequiredBanner: some View {
        HStack (alignment: .center, spacing: 6){
            Image(systemName: "exclamationmark.circle.fill")
            Text("로그인 전 게시물은 공개 범위를 수정할 수 없어요.")
                .font(.Body2)
            
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color.gray500)
        .background(Color.gray800)
        .rounded(radius: 8)
    }
    
    private var category: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("카테고리")
                .font(.SubTitle2)
                .foregroundStyle(Color.gray400)
            
            HStack(alignment: .center, spacing: 9) {
                Image(viewModel.category.image)
                Text(viewModel.category.title)
                    .font(.Btn2_b)
                    .foregroundStyle(Color.gray50)
            }
            
        }
        .frame(width: 120, alignment: .leading)
    }
    
    private var visibility: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("공개 여부")
                .font(.SubTitle2)
                .foregroundStyle(Color.gray400)
            
            TagView(title: viewModel.visibility.title, state: .active)
            
        }
    }
}

#Preview {
    NavigationView {
        LogDetailView(viewModel: LogDetailViewModel(), onGoBack: {})
    }
    
}
