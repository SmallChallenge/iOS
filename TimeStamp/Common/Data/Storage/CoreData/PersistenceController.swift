//
//  PersistenceController.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import CoreData


/// Core Data Stack을 관리하는 컨트롤러
/// - 앱 전체에서 Core Data 작업을 처리하기 위한 싱글톤 객체
/// - NSPersistentContainer를 래핑하여 데이터베이스 접근 제공
final class PersistenceController {

    static let shared = PersistenceController()

    /// Core Data의 모든 객체와 설정을 포함하는 컨테이너
    /// - 데이터 모델, 영구 저장소, 컨텍스트를 관리
    let container: NSPersistentContainer

    /// 메인 스레드에서 UI 작업을 위해 사용하는 컨텍스트
    /// - 데이터 읽기/쓰기 작업의 진입점
    /// - UI와 상호작용하는 모든 Core Data 작업은 이 컨텍스트를 사용
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    /// PersistenceController 초기화
    /// - Parameter environment: 실행 환경 (development: 메모리 저장, production: 디스크 저장)
    init(environment: StorageEnvironment = .production) {
        // "Stampic.xcdatamodeld" 파일을 기반으로 컨테이너 생성
        container = NSPersistentContainer(name: "Stampic")

        if environment == .development { // 테스트, 개발용
            //디스크에 저장하지 않고 메모리에만 데이터 유지
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        // 영구 저장소 로드 (SQLite 데이터베이스 파일 생성 또는 연결)
        // - 백그라운드에서 비동기로 실행되며, 완료 시 클로저 호출
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError(">>>>> [ERROR]Core Data store failed to load: \(error.localizedDescription)")
            }
        }

        /*
         [automaticallyMergesChangesFromParent]
         - 백그라운드 컨텍스트에서 저장된 변경사항을 자동으로 viewContext에 병합
         - true로 설정 시, 다른 컨텍스트에서 데이터가 변경되면 UI가 자동으로 업데이트됨
         - 멀티스레드 환경에서 데이터 동기화 보장
         */
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        /*
         [mergePolicy] Core Data에서 데이터 충돌이 발생했을 때, 어떻게 처리할지
         - NSMergeByPropertyObjectTrumpMergePolicy(기본값): 데이터베이스보다 현재 변경사항 우선(사용자 입력이 최우선)
         - NSOverwriteMergePolicy: 메모리가 무조건 이긴다. 모든 충돌을 무시하고 덮어씀
         - NSRollbackMergePolicy: 충돌 시 메모리 변경사항 버림. 데이터베이스 값으로 되돌림
         - NSErrorMergePolicy: 충돌 시 에러 발생, 개발자가 직접 처리
         */
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    }
}


enum StorageEnvironment {
    /// 개발,테스트 환경 - 메모리에만 데이터 저장 (앱 종료 시 삭제)
    /// (유닛 테스트, 프리뷰, 디버깅용)
    case development

    /// 프로덕션 환경 - 디스크에 영구 저장
    case production
}
