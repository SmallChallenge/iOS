//
//  CameraTabButton.swift
//  TimeStamp
//
//  Created by 임주희 on 12/18/25.
//

import Foundation
import SwiftUI

// 카메라화면 탭 버튼 (갤러리 | 카메라)
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
                .padding(.top, 18.5)
        }
    }
}
