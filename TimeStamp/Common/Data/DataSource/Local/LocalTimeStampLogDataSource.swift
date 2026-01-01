//
//  LocalTimeStampLogDataSource.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import CoreData
import Foundation

/// 로컬 타임스탬프 로그를 관리하는 DataSource
/// - Core Data를 사용하여 TimeStampLogEntity를 LocalTimeStampLogDto로 변환
/// - TimeStampLogEntity의 생성, 조회, 수정, 삭제
final class LocalTimeStampLogDataSource: LocalTimeStampLogDataSourceProtocol {

    /// Core Data Stack을 관리하는 컨트롤러
    private let persistenceController: PersistenceController

    /// Core Data 작업을 수행하는 컨텍스트 (메인 스레드용)
    /// - UI 업데이트와 동기화된 데이터 작업 수행
    private var context: NSManagedObjectContext {
        persistenceController.viewContext
    }

    /// Repository 초기화
    /// - Parameter persistenceController: Core Data Stack (기본값: shared 싱글톤)
    /// - Note: 테스트 시 다른 PersistenceController를 주입할 수 있음
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
    }

    // MARK: - Create

    /// 새로운 타임스탬프 로그를 생성하여 저장
    /// - Parameter log: 저장할 로그 데이터 (DTO)
    /// - Throws: RepositoryError.saveFailed - 저장 실패 시
    /// - Note: DTO를 Entity로 변환하여 Core Data에 저장
    func create(_ log: LocalTimeStampLogDto) throws {
        // DTO를 Core Data Entity로 변환
        let entity = TimeStampLogEntity(context: context)
        entity.id = log.id
        entity.category = log.category
        entity.timeStamp = log.timeStamp.toDate(.iso8601)
        entity.imageFileName = log.imageFileName
        entity.visibility = log.visibility

        // 컨텍스트 변경사항을 디스크에 저장
        try saveContext()
    }

    // MARK: - Read

    /// ID로 특정 타임스탬프 로그를 조회
    /// - Parameter id: 조회할 로그의 UUID
    /// - Returns: 해당하는 로그 DTO, 없으면 nil
    /// - Throws: Core Data fetch 에러
    func read(id: UUID) throws -> LocalTimeStampLogDto? {
        let fetchRequest = TimeStampLogEntity.fetchRequest()
        // ID가 일치하는 로그만 필터링
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1 // 최대 1개만 가져옴 (성능 최적화)

        let entities = try context.fetch(fetchRequest)
        return entities.first.map { toDto($0) }
    }

    /// 모든 타임스탬프 로그를 조회
    /// - Returns: 모든 로그 DTO 배열 (최신순 정렬)
    /// - Throws: Core Data fetch 에러
    func readAll() throws -> [LocalTimeStampLogDto] {
        let fetchRequest = TimeStampLogEntity.fetchRequest()
        // 타임스탬프 기준 내림차순 정렬 (최신 로그가 먼저)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]

        let entities = try context.fetch(fetchRequest)
        return entities.map { toDto($0) }
    }

    /// 특정 카테고리의 타임스탬프 로그를 조회
    /// - Parameter category: 조회할 카테고리명
    /// - Returns: 해당 카테고리의 로그 DTO 배열 (최신순 정렬)
    /// - Throws: Core Data fetch 에러
    func readByCategory(_ category: String) throws -> [LocalTimeStampLogDto] {
        let fetchRequest = TimeStampLogEntity.fetchRequest()
        // 카테고리가 일치하는 로그만 필터링
        fetchRequest.predicate = NSPredicate(format: "category == %@", category)
        // 타임스탬프 기준 내림차순 정렬
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]

        let entities = try context.fetch(fetchRequest)
        return entities.map { toDto($0) }
    }

    /// 로컬 타임스탬프 로그의 총 개수를 조회
    /// - Returns: 로컬에 저장된 로그의 개수
    /// - Throws: Core Data fetch 에러
    func count() throws -> Int {
        let fetchRequest = TimeStampLogEntity.fetchRequest()
        return try context.count(for: fetchRequest)
    }

    // MARK: - Update

    /// 기존 타임스탬프 로그를 수정
    /// - Parameter log: 수정할 로그 데이터 (DTO)
    /// - Throws:
    ///   - RepositoryError.entityNotFound - 해당 ID의 로그가 없을 때
    ///   - RepositoryError.saveFailed - 저장 실패 시
    func update(_ log: LocalTimeStampLogDto) throws {
        let fetchRequest = TimeStampLogEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", log.id as CVarArg)
        fetchRequest.fetchLimit = 1

        // 해당 ID의 Entity를 찾아서 업데이트
        guard let entity = try context.fetch(fetchRequest).first else {
            throw RepositoryError.entityNotFound
        }

        // Entity의 속성 업데이트 (id는 변경 불가)
        entity.category = log.category
        entity.timeStamp = log.timeStamp.toDate(.iso8601)
        entity.imageFileName = log.imageFileName
        entity.visibility = log.visibility

        try saveContext()
    }

    // MARK: - Delete

    /// ID로 특정 타임스탬프 로그를 삭제
    /// - Parameter id: 삭제할 로그의 UUID
    /// - Throws:
    ///   - RepositoryError.entityNotFound - 해당 ID의 로그가 없을 때
    ///   - RepositoryError.saveFailed - 저장 실패 시
    func delete(id: UUID) throws {
        let fetchRequest = TimeStampLogEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        fetchRequest.fetchLimit = 1

        guard let entity = try context.fetch(fetchRequest).first else {
            throw RepositoryError.entityNotFound
        }

        // Core Data 컨텍스트에서 Entity 삭제
        context.delete(entity)
        try saveContext()
    }

    /// 모든 타임스탬프 로그를 삭제
    /// - Throws: RepositoryError.saveFailed - 저장 실패 시
    /// - Warning: 이 작업은 되돌릴 수 없으므로 주의해서 사용
    func deleteAll() throws {
        let fetchRequest = TimeStampLogEntity.fetchRequest()
        let entities = try context.fetch(fetchRequest)

        // 모든 Entity 삭제
        entities.forEach { context.delete($0) }
        try saveContext()
    }

    // MARK: - Private Helpers

    /// 컨텍스트의 변경사항을 저장
    /// - Throws: RepositoryError.saveFailed - 저장 실패 시
    /// - Note:
    ///   - 변경사항이 없으면 저장하지 않음 (성능 최적화)
    ///   - 저장 실패 시 자동으로 롤백하여 데이터 무결성 보장
    private func saveContext() throws {
        // 변경사항이 없으면 저장 건너뛰기
        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch {
            // 저장 실패 시 컨텍스트를 이전 상태로 되돌림
            context.rollback()
            throw RepositoryError.saveFailed(error)
        }
    }

    /// Core Data Entity를 DTO로 변환
    /// - Parameter entity: 변환할 TimeStampLogEntity
    /// - Returns: LocalTimeStampLogDto
    /// - Note: Entity의 옵셔널 값들에 대해 기본값 제공
    private func toDto(_ entity: TimeStampLogEntity) -> LocalTimeStampLogDto {
        LocalTimeStampLogDto(
            id: entity.id ?? UUID(),
            category: entity.category ?? "",
            timeStamp: entity.timeStamp?.toString(.iso8601) ?? (Date().toString(.iso8601)),
            imageFileName: entity.imageFileName ?? "",
            visibility: entity.visibility ?? ""
        )
    }
}

// MARK: - Repository Error

/// Repository 작업 중 발생할 수 있는 에러
enum RepositoryError: Error {
    /// 조회/수정/삭제 시 해당 Entity를 찾을 수 없을 때
    case entityNotFound

    /// Core Data 저장 작업이 실패했을 때
    /// - Parameter Error: 실제 발생한 Core Data 에러
    case saveFailed(Error)

    /// 사용자에게 보여줄 에러 메시지
    var localizedDescription: String {
        switch self {
        case .entityNotFound:
            return "요청한 데이터를 찾을 수 없습니다."
        case .saveFailed(let error):
            return "데이터 저장에 실패했습니다: \(error.localizedDescription)"
        }
    }
}
