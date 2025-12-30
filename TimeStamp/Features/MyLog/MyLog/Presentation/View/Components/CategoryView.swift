//
//  CategoryView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedCategory: CategoryFilterViewData
    let availableCategories: [CategoryFilterViewData]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(availableCategories, id: \.self) { category in
                    CategoryFilterButton(
                        type: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.vertical, 16)
            .padding(.leading, 20)
        }
    }
}

#Preview {
    CategoryView(
        selectedCategory: .constant(.all),
        availableCategories: [.all, .study, .food]
    )
    .background(Color.gray900)
}




