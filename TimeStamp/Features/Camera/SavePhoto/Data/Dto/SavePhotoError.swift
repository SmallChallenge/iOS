//
//  SavePhotoError.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

enum SavePhotoError: LocalizedError {
    case documentsDirectoryNotFound
    case imageConversionFailed
    case networkError

    var errorDescription: String? {
        switch self {
        case .documentsDirectoryNotFound:
            return "Documents 디렉토리를 찾을 수 없습니다."
        case .imageConversionFailed:
            return "이미지를 JPEG 형식으로 변환하는데 실패했습니다."
        case .networkError:
            return "네트워크 오류가 발생했습니다."
        }
    }
}
