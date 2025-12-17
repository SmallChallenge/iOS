//
//  MyLogViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/16/25.
//

import Foundation
import Combine

final class MyLogViewModel: ObservableObject {
    
    
    // MARK: Output Properties...
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var myLogs: [TimeStampLogViewData] = [
        .init(id: UUID(),
              category: .food,
              timeStamp: Date.now,
              imageSource: .remote(TimeStampLog.RemoteTimeStampImage(id: 0, imageUrl: "https://picsum.photos/600/400")),
              visibility: .privateVisible
             ),
        .init(id: UUID(),
              category: .food,
              timeStamp: Date.now,
              imageSource: .remote(TimeStampLog.RemoteTimeStampImage(id: 2, imageUrl: "https://picsum.photos/600/400")),
              visibility: .privateVisible
             ),
        .init(id: UUID(),
              category: .food,
              timeStamp: Date.now,
              imageSource: .remote(TimeStampLog.RemoteTimeStampImage(id: 3, imageUrl: "https://picsum.photos/600/400")),
              visibility: .privateVisible
             ),
        .init(id: UUID(),
              category: .food,
              timeStamp: Date.now,
              imageSource: .remote(TimeStampLog.RemoteTimeStampImage(id: 2, imageUrl: "https://picsum.photos/600/400")),
              visibility: .privateVisible
             ),
        .init(id: UUID(),
              category: .food,
              timeStamp: Date.now,
              imageSource: .remote(TimeStampLog.RemoteTimeStampImage(id: 3, imageUrl: "https://picsum.photos/600/400")),
              visibility: .privateVisible
             )
    ]
    
    // MARK: Input Methods...
    func loadMore() {
        guard !isLoading else { return }

        isLoading = true

        // TODO: 실제 API 호출로 교체
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }

            let newLogs = (0..<9).map { index in
                TimeStampLogViewData(
                    id: UUID(),
                    category: [.food, .study, .health].randomElement()!,
                    timeStamp: Date.now,
                    imageSource: .remote(TimeStampLog.RemoteTimeStampImage(
                        id: self.myLogs.count + index,
                        imageUrl: "https://picsum.photos/400/400?random=\(self.myLogs.count + index)"
                    )),
                    visibility: [.publicVisible, .privateVisible].randomElement()!
                )
            }

            self.myLogs.append(contentsOf: newLogs)
            self.isLoading = false
        }
    }
}
