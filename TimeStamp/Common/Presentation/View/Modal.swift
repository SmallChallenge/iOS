//
//  Modal.swift
//  TimeStamp
//
//  Created by 임주희 on 12/23/25.
//

import SwiftUI

struct Modal: View {
    let title: String
    let content: String?

    init(title: String, content: String? = nil) {
        self.title = title
        self.content = content
    }

    var body: some View {
        VStack(alignment: .center, spacing: 24){

            // 제목, 컨텐츠
            VStack(alignment: .center, spacing: 8) {
                Text(title)
                    .font(.H3)
                    .foregroundStyle(Color.gray50)

                if let content {
                    Text(content)
                        .font(.Body2)
                        .foregroundStyle(Color.gray300)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.top, 32)
        .padding([.bottom, .horizontal], 20)
        .frame(maxWidth: .infinity)
        .background(Color.gray900)
        .cornerRadius(16)
    }

    func buttons<Content: View>(@ViewBuilder _ content: () -> Content) -> some View {
        ModalWithButtons(modal: self, buttons: content())
    }
}

private struct ModalWithButtons<Buttons: View>: View {
    let modal: Modal
    let buttons: Buttons

    var body: some View {
        VStack(alignment: .center, spacing: 24){

            // 제목, 컨텐츠
            VStack(alignment: .center, spacing: 8) {
                Text(modal.title)
                    .font(.H3)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.gray50)

                if let content = modal.content {
                    Text(content)
                        .font(.Body2)
                        .foregroundStyle(Color.gray300)
                }
            }

            // 버튼
            HStack(spacing: 8) {
                buttons
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.top, 32)
        .padding([.bottom, .horizontal], 20)
        .frame(maxWidth: .infinity)
        .background(Color.gray900)
        .cornerRadius(16)
    }
}





#Preview {
    PopupTestView()
}

struct PopupTestView: View {
    @State var isPresented: Bool = false
    @State var showSingleButton: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Hello, World!")

            Button("1개 버튼 팝업") {
                showSingleButton = true
                isPresented = true
            }

            Button("2개 버튼 팝업") {
                showSingleButton = false
                isPresented = true
            }
        }
        .popup(isPresented: $isPresented) {
            if showSingleButton {
                Modal(title: "알림", content: "저장되었습니다")
                    .buttons {
                        MainButton(title: "확인", size: .large) {
                            isPresented = false
                        }
                    }
            } else {
                Modal(title: "삭제", content: "정말 삭제하시겠습니까?")
                    .buttons {
                        MainButton(title: "취소", size: .middle, colorType: .secondary) {
                            isPresented = false
                        }
                        MainButton(title: "확인", size: .middle) {
                            print("삭제됨")
                            isPresented = false
                        }
                    }
            }
        }
    }
}
