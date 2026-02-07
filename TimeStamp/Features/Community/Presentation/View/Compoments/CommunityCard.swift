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
    private let onBlock: () -> Void
    private let onLike: () -> Void

    init(
        viewData: FeedViewData,
        isMenuOpen: Binding<Bool>,
        onReport: @escaping () -> Void,
        onBlock: @escaping () -> Void,
        onLike: @escaping () -> Void
    ) {
        self.viewData = viewData
        self._isMenuOpen = isMenuOpen
        self.onReport = onReport
        self.onBlock = onBlock
        self.onLike = onLike
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
                    isMenuOpen = true
                } label: {
                    ellipsisImage
                        .padding(.vertical, 5)
                        .padding(.horizontal, 20)
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 12)

            
            // 이미지뷰
            logImage
                .aspectRatio(1, contentMode: .fit)//
                .padding(.trailing, 20)
            
            // 좋아요
            HStack(spacing: 0) {
                Button {
                    onLike()
                } label: {
                    HStack(spacing: 6) {
                        if viewData.isLiked {
                            Image(systemName: "heart.fill" )
                                .foregroundStyle(Color.neon300)
                        } else {
                            Image(systemName: "heart")
                                .foregroundStyle(Color.gray50)
                        }
                        Text("\(viewData.likeCount)")
                            .font(.SubTitle2)
                            .foregroundStyle(Color.gray50)
                    }
                }
                .buttonStyle(.plain)
                Spacer()
            }
            .padding(.vertical, 12)
            
        } // ~VStack
        .overlay {
            if isMenuOpen {
                // 배경 (카드 영역 탭하면 닫기)
                Color.black.opacity(0.001)
                    .onTapGesture {
                        isMenuOpen = false
                    }
            }
        }
        .overlay(alignment: .topTrailing) {
            if isMenuOpen {
                // 팝오버 메뉴
                PopoverMenu(items: [
                    .init(title: "게시물 신고", icon: "IconReport", action: {
                        onReport()
                    }),
                    .init(title: "게시자 차단", icon: "IconBlock", action: {
                        onBlock()
                    })
                ], isPresented: $isMenuOpen)
                .padding(.top, 50)
                .padding(.trailing, 10)
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
            KFImage(URL(string: viewData.accessURL))
                .placeholder {
                    Placeholder(width: 48, height: 48)
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
                    }, onBlock: {}, onLike: {}
                )
                .border(Color.red)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.gray900)
        }
    }

    return PreviewWrapper()
}
