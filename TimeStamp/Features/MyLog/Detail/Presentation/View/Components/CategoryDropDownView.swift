//
//  CategoryDropDownView 2.swift
//  TimeStamp
//
//  Created by 임주희 on 4/6/26.
//


import SwiftUI

// MARK: - 메인 뷰
struct CategoryDropDownView: View {
    @Binding var selectedCategory: CategoryViewData
    @State private var isExpanded: Bool = false
    
    var body: some View {
            VStack {
                // 1. 드롭다운 컨테이너
                VStack(spacing: 0) {
                    
                    // 상단 버튼 (선택된 항목 표시)
                    Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            isExpanded.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(selectedCategory.iconImage)
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text(selectedCategory.title)
                                .font(.Btn2_b)
                                .foregroundColor(.gray50)
                            
                            Spacer()
                            
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray300)
                                .rotationEffect(.degrees(isExpanded ? 180 : 0))
                                
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal, 12)
                        .background(Color.gray700)
                    }
                    
                    // 2. 아래로 열리는 리스트 부분
                    if isExpanded {
                        VStack(spacing: 0) {
                            // 구분선 (선택사항)
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .frame(height: 1)
                            
                            ForEach(CategoryViewData.allCases, id: \.self) { category in
                                Button(action: {
                                    withAnimation(.spring()) {
                                        selectedCategory = category
                                        isExpanded = false
                                    }
                                }) {
                                    HStack(spacing: 6) {
                                        Image(category.iconImage)
                                            .resizable()
                                            .frame(width: 16, height: 16)
                                        
                                        Text(category.title)
                                            .font(selectedCategory == category ? .Btn2_b : .Btn2)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        // 이미지에 있던 연두색 체크마크
                                        if selectedCategory == category {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(Color.neon300) // 연두색
                                                .font(.system(size: 14, weight: .bold))
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 12)
                                    .background(selectedCategory == category ? Color.gray600 : Color.clear)
                                }
                            }
                        }
                        .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .background(Color.gray700) // 드롭다운 전체 배경색
                .cornerRadius(8)
                .frame(width: 110) // 드롭다운 전체 너비

                
                Spacer() // 드롭다운이 위쪽에 위치하도록 고정
            }
            
        
    }
}



struct CustomDropDownView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // 전체 배경
            CategoryDropDownView(selectedCategory: .constant(.food))
                .padding(.top, 50)
        }
    }
}
