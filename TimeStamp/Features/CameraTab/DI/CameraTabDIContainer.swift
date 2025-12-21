//
//  CameraTabDIContainer.swift
//  TimeStamp
//
//  Created by 임주희 on 12/21/25.
//

import Foundation

final class CameraTabDIContainer {

    // MARK: - Dependencies

    // CameraTab과 Camera 기능은 현재 외부 의존성이 없음
    // (CameraManager를 직접 생성)

    init() {}
    
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
        return CameraView(viewModel: viewModel, onDismiss: onDismiss)
    }


    
}
