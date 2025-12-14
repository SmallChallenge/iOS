//
//  MyLogView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct MyLogView: View {
    @State private var selectedCategory: Category = .all
    var body: some View {
        VStack {
            HeaderView()
            ScrollView {
                CategoryView(selectedCategory: $selectedCategory)
                Spacer()
                
                Text("MyLogView")
            }
        }.mainBackgourndColor()
    }
}

#Preview {
    MyLogView()
}
