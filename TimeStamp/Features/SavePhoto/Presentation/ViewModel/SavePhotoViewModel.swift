//
//  SavePhotoViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit
import Combine

// MARK: - Notification Names

extension Notification.Name {
    static let didSavePhoto = Notification.Name("didSavePhoto")
}

/// 사진 저장 화면의 비즈니스 로직을 관리하는 ViewModel
@MainActor
final class SavePhotoViewModel: ObservableObject {

    // MARK: - Properties

    /// 사진 저장 UseCase
    private let useCase: SavePhotoUseCaseProtocol

    /// 저장 성공 여부
    @Published var isSaved = false

    /// 에러 메시지
    @Published var errorMessage: String?

    // MARK: - Init

    init(useCase: SavePhotoUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Actions

    /// 사진을 파일로 저장하고 Core Data에 로그 저장
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - category: 선택된 카테고리
    ///   - visibility: 공개 여부
    func savePhoto(image: UIImage, category: String, visibility: String) {
        do {
            try useCase.savePhoto(image: image, category: category, visibility: visibility)

            // 저장 성공
            isSaved = true
            print("✅ 사진 저장 성공")

            // MyLogView에 새로고침 알림
            NotificationCenter.default.post(name: .didSavePhoto, object: nil)

        } catch {
            // 저장 실패
            errorMessage = "사진 저장에 실패했습니다: \(error.localizedDescription)"
            print("❌ 사진 저장 실패: \(error)")
        }
    }
}
