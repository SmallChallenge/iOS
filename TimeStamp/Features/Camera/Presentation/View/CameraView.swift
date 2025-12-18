//
//  CameraView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CameraView: View {
    @Environment(\.dismiss) var dismiss
    @State var selectedTab: CameraViewTab = .camera
    enum CameraViewTab: String, CaseIterable, Identifiable {
        case gallery = "갤러리"
        case camera = "카메라"
        
        var id: String { self.rawValue }
    }
    

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                if selectedTab == .camera {
                    InnerCameraView()
                } else {
                    Spacer()
                }
                
                //갤러리, 카메라 버튼
                HStack(spacing: .zero) {
                    ForEach(CameraViewTab.allCases) { tab in
                        CameraTabButton(
                            title: tab.rawValue,
                            isSelected: selectedTab == tab
                        ) {
                            selectedTab = tab
                        }
                    }
                }
                
                
            } // ~VStack
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.gray50)
                    }
                }
            }
            .mainBackgourndColor()
        } //~ NavigationView
        .statusBarHidden(false)
        .onAppear {
            // 세로 방향으로 고정
            AppDelegate.orientationLock = .portrait
        }
        .onDisappear {
            // 화면을 나갈 때 방향 제한 해제
            AppDelegate.orientationLock = .all
        }
    }
    

}

#Preview {
    CameraView()
}



struct CameraTabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.Btn1)
                .foregroundStyle(isSelected ? .gray50 : .gray500)
                .frame(maxWidth: .infinity)
        }
    }
}
