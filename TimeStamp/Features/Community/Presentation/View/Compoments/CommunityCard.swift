//
//  CommunityCard.swift
//  Stampic
//
//  Created by 임주희 on 1/2/26.
//

import SwiftUI
import Kingfisher

struct CommunityCard: View {
    
    private let imageSource: TimeStampLog.ImageSource = .remote(.init(id: 0, imageUrl: ""))
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 헤더 (프로필 + ...메뉴)
            HStack(spacing: 12) {
                // 이미지뷰
                Image("profile")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text("이름이름")
                    .font(.SubTitle1)
                    .foregroundStyle(Color.gray50)
                
                Spacer()

                Button {
                    //showPopoverMenu = true
                } label: {
                    ellipsisImage
                }
                    
                //
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            
            
            // 이미지뷰
            logImage
                .aspectRatio(1, contentMode: .fit)//
                .padding(.horizontal, 20)
            
                
            
            // 좋아요
            HStack(spacing: 6) {
                
                Image(systemName: "heart")
                    .foregroundStyle(Color.gray50)
                
                Text("18")
                    .font(.SubTitle2)
                    .foregroundStyle(Color.gray50)
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            
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
            
            switch imageSource {

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
}

#Preview {
    VStack{
        CommunityCard()
            .border(Color.red)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray900)
}
