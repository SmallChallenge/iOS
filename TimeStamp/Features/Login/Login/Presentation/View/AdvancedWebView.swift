//
//  AdvancedWebView.swift
//  TimeStamp
//
//  Created by 임주희 on 12/28/25.
//

import Foundation
import UIKit
import SwiftUI
import WebKit

struct AdvancedWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: AdvancedWebView
        
        init(_ parent: AdvancedWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
    }
}

// 사용 예시
struct ContentView: View {
    @State private var isLoading = false
    
    var body: some View {
        ZStack {
            AdvancedWebView(url: URL(string: "https://www.apple.com")!, isLoading: $isLoading)
            
            if isLoading {
                ProgressView()
            }
        }
    }
}
