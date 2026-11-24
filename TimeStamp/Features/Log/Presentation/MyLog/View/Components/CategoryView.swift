//
//  CategoryView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CategoryView: View {
    private let selectedCategory: CategoryFilterViewData
    private let availableCategories: [CategoryFilterViewData]
    private let onTapCategory: (CategoryFilterViewData) -> Void
    
    init(selectedCategory: CategoryFilterViewData,
         availableCategories: [CategoryFilterViewData],
         onTapCategory: @escaping (CategoryFilterViewData) -> Void) {
        self.selectedCategory = selectedCategory
        self.availableCategories = availableCategories
        self.onTapCategory = onTapCategory
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(availableCategories, id: \.self) { category in
                    CategoryFilterButton(
                        type: category,
                        isSelected: selectedCategory == category
                    ) {
                        //selectedCategory = category
                        onTapCategory(category)
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
        selectedCategory: .all,
        availableCategories: [.all, .study, .food],
        onTapCategory: { _ in }
    )
    .background(Color.gray900)
}




