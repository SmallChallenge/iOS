//
//  SegmentedToggleView.swift
//  TimeStamp
//
//  Created by 임주희 on 4/6/26.
//


import SwiftUI


struct SegmentedToggleView: View {
    
    @Binding var selectedTab: VisibilityViewData
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            tabButton(title: "비공개", tab: .privateVisible)
            tabButton(title: "전체공개", tab: .publicVisible)
        }
        
        .padding(4)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: selectedTab)
    }
    
    private func tabButton(title: String, tab: VisibilityViewData) -> some View {
        Button {
            selectedTab = tab
        } label: {
            ZStack {
                if selectedTab == tab {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray700)
                        .matchedGeometryEffect(id: "background", in: animation)
                }
                
                Text(title)
                    .font(.Btn2)
                    .foregroundColor(selectedTab == tab ? .gray50 : .gray400)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SegmentedToggleView(selectedTab: .constant(.privateVisible))
        
}
