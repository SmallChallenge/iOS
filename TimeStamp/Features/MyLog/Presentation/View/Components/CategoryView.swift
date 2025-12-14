//
//  CategoryView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/14/25.
//

import SwiftUI

struct CategoryView: View {
    @Binding var selectedCategory: Category
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Category.allCases, id: \.self) { category in
                    CategoryButton(
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
    CategoryView(selectedCategory: .constant(.all))
        .background(Color.gray900)
}




