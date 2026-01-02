//
//  CommunityCard.swift
//  Stampic
//
//  Created by 임주희 on 1/2/26.
//

import SwiftUI
import Kingfisher

struct CommunityCard: View {

    private let viewData: FeedViewData
    @Binding var isMenuOpen: Bool
    private let onReport: () -> Void

    init(
        viewData: FeedViewData,
        isMenuOpen: Binding<Bool>,
        onReport: @escaping () -> Void
    ) {
        self.viewData = viewData
        self._isMenuOpen = isMenuOpen
        self.onReport = onReport
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 헤더 (프로필 + ...메뉴)
            HStack(spacing: 12) {
                // 프로필 이미지
                Image("profile")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text(viewData.nickname)
                    .font(.SubTitle1)
                    .foregroundStyle(Color.gray50)
                
                Spacer()

                Button {
                    isMenuOpen.toggle()
                } label: {
                    ellipsisImage
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                }
            }
            .padding(.vertical, 12)

            
            // 이미지뷰
            logImage
                .aspectRatio(1, contentMode: .fit)//
                .padding(.trailing, 20)
            
            // 좋아요
            HStack(spacing: 6) {
                
                Image(systemName: viewData.isLiked ? "heart.fill" : "heart")
                    .foregroundStyle(Color.gray50)
                
                Text("\(viewData.likeCount)")
                    .font(.SubTitle2)
                    .foregroundStyle(Color.gray50)
                Spacer()
            }
            .padding(.vertical, 12)
            
        } // ~VStack
        .overlay {
            if isMenuOpen {
                ZStack(alignment: .topTrailing) {
                    // 배경 (카드 영역 탭하면 닫기)
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            isMenuOpen = false
                        }

                    // 팝오버 메뉴
                    VStack {
                        PopoverMenu(items: [
                            .init(title: "신고하기", icon: "exclamationmark.triangle", action: {
                                onReport()
                            })
                            
                        ], isPresented: $isMenuOpen)
                            .padding(.top, 50)
                            .padding(.trailing, 10)
                        Spacer()
                    }
                }
            }
        }
        .zIndex(isMenuOpen ? 999 : 0)
    }
    
    private var ellipsisImage: some View {
        Image(systemName: "ellipsis")
            .foregroundStyle(Color.gray50)
            .padding(.vertical, 10.11)
            .padding(.horizontal, 2.53)
    }
    
    private var logImage: some View {
        Group {
            KFImage(URL(string: viewData.accessURL))
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
        }
        .clipped()
            .aspectRatio(1, contentMode: .fill)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .roundedBorder(color: .gray700, radius: 8)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var isMenuOpen = false

        var body: some View {
            VStack{
                CommunityCard(
                    viewData: .init(
                        imageId: 1,
                        accessURL: "https://picsum.photos/300/300",
                        nickname: "홍길동전이",
                        profileImageURL: nil,
                        isLiked: true,
                        likeCount: 52
                    ),
                    isMenuOpen: $isMenuOpen,
                    onReport: {
                        print("신고하기 클릭")
                    }
                )
                .border(Color.red)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray900)
        }
    }

    return PreviewWrapper()
}
