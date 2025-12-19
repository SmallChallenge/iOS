//
//  SavePhotoViewModel.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation
import UIKit
import Combine

/// 사진 저장 화면의 비즈니스 로직을 관리하는 ViewModel
@MainActor
final class SavePhotoViewModel: ObservableObject {

    // MARK: - Properties

    /// 로컬 타임스탬프 로그 저장소
    private let repository: LocalTimeStampLogRepositoryProtocol

    /// 저장 성공 여부
    @Published var isSaved = false

    /// 에러 메시지
    @Published var errorMessage: String?

    // MARK: - Init

    init(repository: LocalTimeStampLogRepositoryProtocol) {
        self.repository = repository
    }

    // MARK: - Actions

    /// 사진을 파일로 저장하고 Core Data에 로그 저장
    /// - Parameters:
    ///   - image: 저장할 이미지
    ///   - category: 선택된 카테고리
    ///   - visibility: 공개 여부
    func savePhoto(image: UIImage, category: String, visibility: String) {
        do {
            // 1. 이미지를 파일로 저장
            let fileName = try saveImageToDocuments(image: image)

            // 2. Core Data에 로그 저장
            let log = LocalTimeStampLogDto(
                id: UUID(),
                category: category,
                timeStamp: Date(),
                imageFileName: fileName,
                visibility: visibility
            )

            try repository.create(log)

            // 저장 성공
            isSaved = true
            print("✅ 사진 저장 성공: \(fileName)")

        } catch {
            // 저장 실패
            errorMessage = "사진 저장에 실패했습니다: \(error.localizedDescription)"
            print("❌ 사진 저장 실패: \(error)")
        }
    }

    // MARK: - Private Helpers

    /// 이미지를 Documents 디렉토리에 저장
    /// - Parameter image: 저장할 이미지
    /// - Returns: 저장된 파일명
    /// - Throws: 파일 저장 실패 시 에러
    private func saveImageToDocuments(image: UIImage) throws -> String {
        // 고유한 파일명 생성 (UUID + timestamp)
        let fileName = "\(UUID().uuidString)_\(Date().timeIntervalSince1970).jpg"

        // Documents 디렉토리 경로 가져오기
        guard let documentsDirectory = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first else {
            throw SavePhotoError.documentsDirectoryNotFound
        }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        // 이미지를 JPEG 데이터로 변환 (압축률 0.8)
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw SavePhotoError.imageConversionFailed
        }

        // 파일로 저장
        try imageData.write(to: fileURL)

        return fileName
    }
}

// MARK: - Save Photo Error

/// 사진 저장 중 발생할 수 있는 에러
enum SavePhotoError: Error, LocalizedError {
    case documentsDirectoryNotFound
    case imageConversionFailed

    var errorDescription: String? {
        switch self {
        case .documentsDirectoryNotFound:
            return "Documents 디렉토리를 찾을 수 없습니다."
        case .imageConversionFailed:
            return "이미지 변환에 실패했습니다."
        }
    }
}
