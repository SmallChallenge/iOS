//
//  CameraDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation
import UIKit
import Alamofire

protocol CameraDIContainerProtocol {
    func makeCameraTabView(onDismiss: @escaping () -> Void) -> CameraTabView
    func makeCameraView(onDismiss: @escaping () -> Void) -> CameraView
    func makeSavePhotoView(
        capturedImage: UIImage,
        onDismiss: @escaping () -> Void,
        onGoBack: (() -> Void)?
    ) -> SavePhotoView
}

final class CameraDIContainer: CameraDIContainerProtocol {

    // MARK: - Dependencies

    // CameraTab과 Camera 기능은 현재 외부 의존성이 없음
    // (CameraManager를 직접 생성)
    
    // save photo용
    private let localDataSource: LocalTimeStampLogDataSourceProtocol
    private let session: Session

    init(session: Session, localDataSource: LocalTimeStampLogDataSourceProtocol) {
        self.session = session
        self.localDataSource = localDataSource
    }
    
    // MARK: - CameraTab Feature

    func makeCameraTabView(onDismiss: @escaping () -> Void) -> CameraTabView {
        return CameraTabView(
            diContainer: self,
            onDismiss: onDismiss
        )
    }

    // MARK: - Camera Feature

    
    private func makeCameraViewModel() -> CameraViewModel {
        return CameraViewModel()
    }
    
    func makeCameraView(onDismiss: @escaping () -> Void) -> CameraView {
        let viewModel = makeCameraViewModel()
        return CameraView(
            viewModel: viewModel,
            diContainer: self,
            onDismiss: onDismiss
        )
    }

    // MARK: - Save Photo feature

    private func makeSavePhotoApiClient() -> SavePhotoApiClientProtocol {
        return SavePhotoApiClient(session: session)
    }

    private func makeSavePhotoRepository() -> SavePhotoRepositoryProtocol {
        return SavePhotoRepository(
            localDataSource: localDataSource,
            apiClient: makeSavePhotoApiClient()
        )
    }
    
    private func makeSavePhotoUseCase() -> SavePhotoUseCaseProtocol {
        return SavePhotoUseCase(repository: makeSavePhotoRepository())
    }
    
    private func makeSavePhotoViewModel() -> SavePhotoViewModel {
        return SavePhotoViewModel(useCase: makeSavePhotoUseCase())
    }
    
    func makeSavePhotoView(
        capturedImage: UIImage,
        onDismiss: @escaping () -> Void,
        onGoBack: (() -> Void)? = nil
    ) -> SavePhotoView {
        let viewModel = makeSavePhotoViewModel()
        return SavePhotoView(
            viewModel: viewModel,
            capturedImage: capturedImage,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }
    
}


// MARK: Mock
struct MockCameraDIContainer: CameraDIContainerProtocol {
    func makeCameraTabView(onDismiss: @escaping () -> Void) -> CameraTabView {
        CameraTabView(diContainer: self, onDismiss: {})
    }
    
    func makeCameraView(onDismiss: @escaping () -> Void) -> CameraView {
        let viewModel = CameraViewModel()
        return CameraView(
            viewModel: viewModel,
            diContainer: self,
            onDismiss: onDismiss
        )
    }
    
    struct MockSavePhotoUseCase: SavePhotoUseCaseProtocol {
        func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType) throws {}
        func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType) async throws {}
    }
    
    private func makeSavePhotoViewModel() -> SavePhotoViewModel {
        return SavePhotoViewModel(useCase: MockSavePhotoUseCase())
    }
    func makeSavePhotoView(capturedImage: UIImage, onDismiss: @escaping () -> Void, onGoBack: (() -> Void)?) -> SavePhotoView {
        let viewModel = makeSavePhotoViewModel()
        return SavePhotoView(
            viewModel: viewModel,
            capturedImage: capturedImage,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }
}
