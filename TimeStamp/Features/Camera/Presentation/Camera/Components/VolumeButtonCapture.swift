//
//  VolumeButtonCapture.swift
//  TimeStamp
//
//  Created by 임주희 on 11/23/26.
//


import SwiftUI
import AVKit

struct VolumeButtonCapture: UIViewRepresentable {
    let onCapture: () -> Void

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        if #available(iOS 17.2, *) {
            let interaction = AVCaptureEventInteraction { event in
                if event.phase == .ended { onCapture() }
            }
            view.addInteraction(interaction)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}