//
//  BottomSheet.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import SwiftUI

struct BottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let dismissOnBackgroundTap: Bool
    let onDismiss: (() -> Void)?
    let content: Content

    init(
        isPresented: Binding<Bool>,
        dismissOnBackgroundTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.dismissOnBackgroundTap = dismissOnBackgroundTap
        self.onDismiss = onDismiss
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isPresented {
                // 배경 dim
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        if dismissOnBackgroundTap {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isPresented = false
                            }
                        }
                    }

                // 바텀시트 컨텐츠
                VStack(spacing: 0) {
                    Spacer()

                    VStack(spacing: 0) {
                        content
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.gray900)
                    .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
                }
                .ignoresSafeArea(edges: .bottom)
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isPresented)
        .onChange(of: isPresented) { newValue in
            if !newValue {
                onDismiss?()
            }
        }
    }
}

// MARK: - ViewModifier

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let dismissOnBackgroundTap: Bool
    let onDismiss: (() -> Void)?
    let sheetContent: () -> SheetContent

    func body(content: Content) -> some View {
        ZStack {
            content
            BottomSheet(
                isPresented: $isPresented,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                onDismiss: onDismiss,
                content: sheetContent
            )
        }
    }
}

extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        dismissOnBackgroundTap: Bool = true,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.modifier(
            BottomSheetModifier(
                isPresented: isPresented,
                dismissOnBackgroundTap: dismissOnBackgroundTap,
                onDismiss: onDismiss,
                sheetContent: content
            )
        )
    }
}

// MARK: - Helper for rounded corners

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Preview

#Preview {
    BottomSheetTestView()
}

struct BottomSheetTestView: View {
    @State private var showBottomSheet = false

    var body: some View {
        VStack {
            Text("Hello, World!")

            Button("바텀시트 열기") {
                showBottomSheet = true
            }
        }
        .bottomSheet(isPresented: $showBottomSheet) {
            VStack(spacing: 20) {
                Text("바텀시트 내용")
                    .font(.H2)
                    .foregroundStyle(Color.gray50)

                Text("화면 절반 정도 올라오는 바텀시트입니다.")
                    .font(.Body2)
                    .foregroundStyle(Color.gray300)

                MainButton(title: "확인", size: .large) {
                    showBottomSheet = false
                }
            }
            .padding(20)
            .frame(height: UIScreen.main.bounds.height * 0.5)
        }
    }
}
