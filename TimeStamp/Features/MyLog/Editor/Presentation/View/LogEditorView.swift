//
//  LogEditorView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/31/25.
//

import SwiftUI
import Kingfisher


struct LogEditorView: View {
    @StateObject private var viewModel: LogEditorViewModel
    let onDismiss: (_ hasEdited: Bool) -> Void
    init(viewModel: LogEditorViewModel, onDismiss: @escaping (_ hasEdited: Bool) -> Void) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.onDismiss = onDismiss
    }
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // 이미지 뷰
                    logImage
                    Text("왜 이러는 거야")
                    Spacer()
                    
                    
                    
                }// ~Vstack
                .padding(.horizontal, 20)
            } //~ScrollView
            .mainBackgourndColor()
                .navigationBarTitleDisplayMode(.inline)
//                .navigationBarBackButtonHidden(true)
                .toolbar {
                    // 뒤로가기 버튼
                    ToolbarItem(placement: .navigationBarLeading) {
                        BackButton {
                            onDismiss(false)
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        MainButton(title: "완료", size: .small) {
                            // TODO: 수정하기
                        }
                        .disabled(viewModel.isLoading)
                    }
                }
            
            
        } // ~NavigationView
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
}

#Preview {
    LogEditorView(viewModel: LogEditorViewModel(log: .init(
        id: UUID(),
        category: .food,
        timeStamp: Date(),
        imageSource: .local(.init(imageFileName: "")),
        visibility: .privateVisible)), onDismiss: {hasEdited in })
}

import Foundation
import Combine

final class LogEditorViewModel: ObservableObject {
    @Published var log: TimeStampLogViewData
    
    // MARK: - Output Properties
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var alertMessage: String?
    
    init(log: TimeStampLogViewData) {
        self.log = log
    }

}
