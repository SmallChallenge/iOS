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
    func makePhotoSaveView(
        capturedImage: UIImage,
        onDismiss: @escaping () -> Void,
        onGoBack: (() -> Void)?
    ) -> PhotoSaveView
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

    private func makePhotoSaveApiClient() -> PhotoSaveApiClientProtocol {
        return PhotoSaveApiClient(session: session)
    }

    private func makePhotoSaveRepository() -> PhotoSaveRepositoryProtocol {
        return PhotoSaveRepository(
            localDataSource: localDataSource,
            apiClient: makePhotoSaveApiClient()
        )
    }
    
    private func makePhotoSaveUseCase() -> PhotoSaveUseCaseProtocol {
        return PhotoSaveUseCase(repository: makePhotoSaveRepository())
    }
    
    private func makePhotoSaveViewModel() -> PhotoSaveViewModel {
        return PhotoSaveViewModel(useCase: makePhotoSaveUseCase())
    }
    
    func makePhotoSaveView(
        capturedImage: UIImage,
        onDismiss: @escaping () -> Void,
        onGoBack: (() -> Void)? = nil
    ) -> PhotoSaveView {
        let viewModel = makePhotoSaveViewModel()
        return PhotoSaveView(
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
    
    struct MockPhotoSaveUseCase: PhotoSaveUseCaseProtocol {
        func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType) throws {}
        
        func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType) async throws {}
    }
    
    private func makePhotoSaveViewModel() -> PhotoSaveViewModel {
        return PhotoSaveViewModel(useCase: MockPhotoSaveUseCase())
    }
    func makePhotoSaveView(capturedImage: UIImage, onDismiss: @escaping () -> Void, onGoBack: (() -> Void)?) -> PhotoSaveView {
        let viewModel = makePhotoSaveViewModel()
        return PhotoSaveView(
            viewModel: viewModel,
            capturedImage: capturedImage,
            onGoBack: onGoBack,
            onDismiss: onDismiss
        )
    }
}
