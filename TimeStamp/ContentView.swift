//
//  ContentView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/4/25.
//

import SwiftUI

struct ContentView: View {
    @State var isPresented = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Button {
                isPresented.toggle()
            } label: {
                Text("로그인")
            }

        }
        .fullScreenCover(isPresented: $isPresented, content: {
            // DI 설정
            let session = SessionFactory().makeSession(for: .prod)
            let repo = LoginRepository(authApiClient: AuthApiClient(session: session))
            let usecase = LoginUseCase(repository: repo)

            let vm = LoginViewModel(useCase: usecase)
            LoginView(viewModel: vm)
        })
        .padding()
    }
}

#Preview {
    ContentView()
}
