//
//  PhotoCell.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import SwiftUI
import Kingfisher
import Photos

struct PhotoCell: View {
    let log: TimeStampLogViewData

    var body: some View {
        GeometryReader { geometry in
            Group {
                switch log.imageSource {
                    // 서버이미지
                case let .remote(remoteImage):
                    KFImage(URL(string: remoteImage.imageUrl))
                        .placeholder {
                            //Image("placeholder")
                            Color.gray100
                                .overlay {
                                    Image(systemName: "photo")
                                }
                        }
                        .retry(maxCount: 3, interval: .seconds(2))
                        .cacheMemoryOnly()
                        .onFailure { error in
                            print("Image load failed: \(error.localizedDescription)")
                        }
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFill()

                    // 로컬 이미지
                case let .local(localImage):
                    PHAssetImageView(
                        assetIdentifier: localImage.assetIdentifier,
                        targetSize: CGSize(width: geometry.size.width * 2, height: geometry.size.width * 2)
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.width)
            .clipped()
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    PhotoCell(
        log: TimeStampLogViewData(
            id: UUID(),
            category: .food,
            timeStamp: Date.now,
            caption: "test",
            imageSource: .remote(TimeStampLog.RemoteTimeStampImage(
                id: 0,
                imageUrl: "https://picsum.photos/400/400"
            )),
            visibility: .privateVisible
        )
    )
    .frame(width: 120, height: 120)
}
