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
    
    // 카메라 화면
    func makeCameraView(
        onCaptured: @escaping (UIImage) -> Void
    ) -> CameraView
    
    // 갤러리
    func makeGalleryView(
        onImageSelected: @escaping (UIImage, Date?) -> Void
    ) -> GalleryView
    
    // 사진 수정
    func makeEditorView(
        capturedImage: UIImage,
        capturedDate: Date,
        onGoBack: (() -> Void)?,
        onComplete: @escaping () -> Void
    ) -> EditorView
    
    // 사진 저장
    func makePhotoSaveView(
        capturedImage: UIImage,
        onGoBack: (() -> Void)?,
        onComplete: @escaping () -> Void
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
    
    func makeCameraView(
        onCaptured: @escaping (UIImage) -> Void
    ) -> CameraView {
        let viewModel = makeCameraViewModel()
        return CameraView(
            viewModel: viewModel,
            onCaptured: onCaptured
        )
    }

    // MARK: - Gallery Feature

    private func makePhotoLibraryRepository() -> PhotoLibraryRepositoryProtocol {
        return PhotoLibraryRepository()
    }

    private func makeGalleryUseCase() -> GalleryUseCaseProtocol {
        return GalleryUseCase(repository: makePhotoLibraryRepository())
    }

    private func makeGalleryViewModel() -> GalleryViewModel {
        return GalleryViewModel(useCase: makeGalleryUseCase())
    }

    func makeGalleryView(
        onImageSelected: @escaping (UIImage, Date?) -> Void
    ) -> GalleryView {
        let viewModel = makeGalleryViewModel()
        return GalleryView(
            viewModel: viewModel,
            onImageSelected: onImageSelected
        )
    }

    // MARK: - EditorView
    private func makeEditorRepository() -> AdRepositoryProtocol {
        return AdMobRepository()
    }
    private func makeEditorUseCase() -> EditorUseCaseProtocol {
        let repo = makeEditorRepository()
        return EditorUseCase(repository: repo)
    }
    
    private func makeEditorViewModel() -> EditorViewModel {
        let useCase = makeEditorUseCase()
        return EditorViewModel(useCase: useCase)
    }
    
    func makeEditorView(
        capturedImage: UIImage,
        capturedDate: Date,
        onGoBack: (() -> Void)?,
        onComplete: @escaping () -> Void
    ) -> EditorView {
        let vm = makeEditorViewModel()
        return EditorView(
            viewModel: vm,
            capturedImage: capturedImage,
            capturedDate: capturedDate,
            diContainer: self,
            onGoBack: onGoBack,
            onComplete: onComplete
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
        onGoBack: (() -> Void)? = nil,
        onComplete: @escaping () -> Void
    ) -> PhotoSaveView {
        let viewModel = makePhotoSaveViewModel()
        return PhotoSaveView(
            viewModel: viewModel,
            capturedImage: capturedImage,
            onGoBack: onGoBack,
            onComplete: onComplete
        )
    }
    
}


// MARK: - Mock

struct MockCameraDIContainer: CameraDIContainerProtocol {
    func makeCameraTabView(onDismiss: @escaping () -> Void) -> CameraTabView {
        CameraTabView(diContainer: self, onDismiss: {})
    }

    func makeCameraView(
        onCaptured: @escaping (UIImage) -> Void
    ) -> CameraView {
        let viewModel = CameraViewModel()
        return CameraView(
            viewModel: viewModel,
            onCaptured: onCaptured
        )
    }

    private func makePhotoLibraryRepository() -> PhotoLibraryRepositoryProtocol {
        return PhotoLibraryRepository()
    }

    private func makeGalleryUseCase() -> GalleryUseCaseProtocol {
        return GalleryUseCase(repository: makePhotoLibraryRepository())
    }

    private func makeGalleryViewModel() -> GalleryViewModel {
        return GalleryViewModel(useCase: makeGalleryUseCase())
    }

    func makeGalleryView(
        onImageSelected: @escaping (UIImage, Date?) -> Void
    ) -> GalleryView {
        let viewModel = makeGalleryViewModel()
        return GalleryView(
            viewModel: viewModel,
            onImageSelected: onImageSelected
        )
    }

    // MARK: - EditorView

    func makeEditorView(
        capturedImage: UIImage,
        capturedDate: Date,
        onGoBack: (() -> Void)?,
        onComplete: @escaping () -> Void
    ) -> EditorView {
        let useCase = MockEditorUsecase()
        let viewModel = EditorViewModel(useCase: useCase)
        return EditorView(
            viewModel: viewModel,
            capturedImage: capturedImage,
            capturedDate: capturedDate,
            diContainer: self,
            onGoBack: onGoBack,
            onComplete: onComplete
        )
    }
    struct MockEditorUsecase: EditorUseCaseProtocol {
        func execute(from: UIViewController) async throws -> Int {
            return 1
        }
        func load() async throws {}
    }
    
    // MARK: - PhotoSave

    struct MockPhotoSaveUseCase: PhotoSaveUseCaseProtocol {
        func savePhotoToGallery(image: UIImage) {}
        func savePhotoToLacal(image: UIImage, category: Category, visibility: VisibilityType) throws {}
        func savePhotoToServer(image: UIImage, category: Category, visibility: VisibilityType) async throws {}
    }
    
    private func makePhotoSaveViewModel() -> PhotoSaveViewModel {
        return PhotoSaveViewModel(useCase: MockPhotoSaveUseCase())
    }
    func makePhotoSaveView(
        capturedImage: UIImage,
        onGoBack: (() -> Void)?,
        onComplete: @escaping () -> Void
    ) -> PhotoSaveView {
        let viewModel = makePhotoSaveViewModel()
        return PhotoSaveView(
            viewModel: viewModel,
            capturedImage: capturedImage,
            onGoBack: onGoBack,
            onComplete: onComplete
        )
    }
}

