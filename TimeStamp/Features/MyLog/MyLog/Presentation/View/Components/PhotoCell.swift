//
//  PhotoCell.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import SwiftUI
import Kingfisher
import Photos
import Foundation

struct PhotoCell: View {
    let log: TimeStampLogViewData

    private let cellSize = UIScreen.main.bounds.width / 3

    var body: some View {
        GeometryReader { geometry in
            Group {
                switch log.imageSource {

                    // MARK: 서버이미지
                case let .remote(remoteImage):
                    
                    KFImage(URL(string: remoteImage.imageUrl))
                        .placeholder {
                            Placeholder()
                        }
                        .setProcessor(DownsamplingImageProcessor(size: CGSize(width: cellSize * UIScreen.main.scale, height: cellSize * UIScreen.main.scale)))
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
                    LocalImageView(
                        imageFileName: localImage.imageFileName,
                        targetSize: CGSize(width: cellSize, height: cellSize)
                    )
                    
                } //~switch
            } //~Group
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
            imageSource: .remote(TimeStampLog.RemoteTimeStampImage(
                id: 0,
                imageUrl: "https://picsum.photos/400/400"
            )),
            visibility: .privateVisible
        )
    )
    .frame(width: 120, height: 120)
}
