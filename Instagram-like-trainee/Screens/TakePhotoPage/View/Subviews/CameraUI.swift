//
//  CameraUI.swift
//  Instagram-like-trainee
//
//  Created by  on 12.12.25.
//

import UIKit
import AVFoundation

class CameraUI: UIView {
    var previewLayer:AVCaptureVideoPreviewLayer?
    
    init(session: AVCaptureSession){
        super.init(frame: .zero)
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = .resizeAspectFill
        layer.addSublayer(preview)
        previewLayer = preview
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = bounds
    }
    
}
