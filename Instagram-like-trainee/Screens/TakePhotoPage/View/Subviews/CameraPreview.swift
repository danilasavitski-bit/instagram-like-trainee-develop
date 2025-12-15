//
//  CameraPreview.swift
//  Instagram-like-trainee
//
//  Created by  on 12.12.25.
//
import SwiftUI
import AVFoundation

struct CameraPreview:UIViewRepresentable{
    let session: AVCaptureSession
    
    func makeUIView(context: Context) -> UIView {
        CameraUI(session: session)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
}
