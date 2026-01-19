//
//  PopoverMenu.swift
//  TimeStamp
//
//  Created by 임주희 on 12/30/25.
//

import SwiftUI

struct PopoverMenu: View {
    let items: [MenuItem]
    @Binding var isPresented: Bool

    struct MenuItem: Identifiable {
        let id = UUID()
        let title: String
        let icon: String
        let isDestructive: Bool
        let action: () -> Void

        init(title: String, icon: String, isDestructive: Bool = false, action: @escaping () -> Void) {
            self.title = title
            self.icon = icon
            self.isDestructive = isDestructive
            self.action = action
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button {
                    item.action()
                    isPresented = false
                } label: {
                    HStack(spacing: 12) {
                       
                        Text(item.title)
                            .font(.Btn1_b)
                            .foregroundStyle(item.isDestructive ? Color.red : Color.gray300)
                        
                        Spacer()
                        
                        Image(item.icon)
                            .renderingMode(.template)
                            .foregroundStyle(item.isDestructive ? Color.red : Color.gray300)

                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 18)
                }

                if index < items.count - 1 {
                    Divider()
                        .background(Color.gray300)
                }
            }
        }
        .frame(maxWidth: 180)
        .background(Color.gray600)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.3), radius: 8, x: 0, y: 2)

    }
}

#Preview {
    ZStack {
        Color.gray800.ignoresSafeArea()

        VStack {
            Spacer()
            PopoverMenu(
                items: [
                    .init(title: "기록 수정", icon: "square.and.pencil") { print("수정") },
                    .init(title: "기록 삭제", icon: "trash", isDestructive: false) { print("삭제") }
                ],
                isPresented: .constant(true)
            )
            .padding()
            Spacer()
        }
    }
}
