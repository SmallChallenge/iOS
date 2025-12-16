//
//  MyLogView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct MyLogView: View {
    @State private var selectedCategory: CategoryViewData = .all
    
    private let isEmpty: Bool = true
    
    var body: some View {
        VStack {
            HeaderView()
            if isEmpty { // 내기록 없음
                MyLogEmptyView()
                
            } else { // 내 기록 있음.
                ScrollView {
                    CategoryView(selectedCategory: $selectedCategory)
                    
                    // 사진 목록
                    Spacer()
                    Text("MyLogView")
                }
            }
        }.mainBackgourndColor()
    }
}

#Preview {
    MyLogView()
}
