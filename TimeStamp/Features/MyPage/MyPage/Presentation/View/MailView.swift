//
//  MailView.swift
//  TimeStamp
//
//  Created by 임주희 on 3/3/26.
//


import SwiftUI
import MessageUI
import UIKit

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    
    let userId: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        
        // 1. 받는 사람 & 제목 설정
        vc.setToRecipients([AppConstants.URLs.supportEmail])
        vc.setSubject("[Stampic] 서비스문의")
        
        // 3. 본문 구성 (HTML이 아닌 일반 텍스트 모드)
        let body = EmailHelper.getSupportEmailBody(userId: userId)
        vc.setMessageBody(body, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        init(_ parent: MailView) { self.parent = parent }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            parent.presentation.wrappedValue.dismiss()
        }
    }
}
