//
//  MyLogRepository.swift
//  TimeStamp
//
//  Created by 임주희 on 12/20/25.
//

import Foundation

/// MyLog Repository 구현 (Data Layer)
/// - LocalTimeStampLogDataSource를 사용하여 로컬 데이터 관리
/// - 나중에 RemoteAPI 추가 가능
final class MyLogRepository: MyLogRepositoryProtocol {

    // MARK: - Properties

    /// 로컬 저장소 (CoreData)
    private let localDataSource: LocalTimeStampLogDataSourceProtocol

    // TODO: 나중에 추가
    // private let remoteDataSource: RemoteTimeStampLogDataSourceProtocol

    // MARK: - Init

    init(localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.localDataSource = localDataSource
    }

    // MARK: - MyLogRepositoryProtocol

    /// 모든 타임스탬프 로그를 조회
    func fetchAllLogs() throws -> [TimeStampLog] {
        // 현재는 로컬에서만 조회
        // TODO: 나중에 서버에서도 조회하여 병합
        let dtos = try localDataSource.readAll()
        return dtos.map { toEntity($0) }
    }

    /// 특정 ID의 타임스탬프 로그를 조회
    func fetchLog(by id: UUID) throws -> TimeStampLog? {
        guard let dto = try localDataSource.read(id: id) else {
            return nil
        }
        return toEntity(dto)
    }

    // MARK: - Private Helpers

    /// DTO를 Entity로 변환
    private func toEntity(_ dto: LocalTimeStampLogDto) -> TimeStampLog {
        // Category rawValue로 변환
        let category = Category(rawValue: dto.category) ?? .etc

        // Visibility 문자열을 enum으로 변환
        let visibility: VisibilityType
        switch dto.visibility {
        case "publicVisible":
            visibility = .publicVisible
        case "privateVisible":
            visibility = .privateVisible
        default:
            visibility = .privateVisible
        }

        // ImageSource 생성 (로컬 이미지)
        let imageSource = TimeStampLog.ImageSource.local(
            TimeStampLog.LocalTimeStampImage(imageFileName: dto.imageFileName)
        )

        return TimeStampLog(
            id: dto.id,
            category: category,
            timeStamp: dto.timeStamp.toDate(.iso8601) ?? Date(),
            imageSource: imageSource,
            visibility: visibility
        )
    }
}
