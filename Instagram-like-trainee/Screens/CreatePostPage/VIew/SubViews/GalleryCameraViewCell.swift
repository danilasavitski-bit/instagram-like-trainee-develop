//
//  GalleryCameraViewCell.swift
//  Instagram-like-trainee
//
//  Created by  on 11.12.25.
//

import UIKit
import AVFoundation

class GalleryCameraViewCell: UICollectionViewCell {
    let placeholderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "camera")
        imageView.tintColor = .gray.withAlphaComponent(0.7)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var previewLayer:AVCaptureVideoPreviewLayer?
    let session = AVCaptureSession()
    
    override init (frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
        requestCameraAccess { granted in
            if granted {
                self.setupCamera()
            }
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        previewLayer?.frame = contentView.bounds
    }
    
    private func requestCameraAccess(completion: @escaping (Bool) -> Void) {
        let cameraAthorizationSttus = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch cameraAthorizationSttus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    completion(granted)
                }
            }
        case .authorized:
            completion(true)
        default:
            completion(false)
        }
    }
    private func setupCamera(){
        guard let device = AVCaptureDevice.default(for: .video) else{
            print("error")
            return
        }
        do{
            let input = try AVCaptureDeviceInput(device: device)
            let output = AVCaptureVideoDataOutput()
            
            session.beginConfiguration()
            if session.canAddInput(input){
                session.addInput(input)
            }
            if session.canAddOutput(output){
                session.addOutput(output)
            }
            session.commitConfiguration()
            
            
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill
            
            contentView.layer.insertSublayer(previewLayer!, at: 0)
            DispatchQueue.global(qos: .userInitiated).async{[weak self] in
                self?.session.startRunning()
            }
        } catch {
            
        }
    }
    private func configureUI() {
        contentView.addSubview(placeholderImageView)
        NSLayoutConstraint.activate([
            placeholderImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            placeholderImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            placeholderImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            placeholderImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
}
