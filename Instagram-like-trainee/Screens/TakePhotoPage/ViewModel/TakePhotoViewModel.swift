//
//  TakePhotoViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 12.12.25.
//
import Foundation
import AVFoundation
import UIKit
import Photos

class TakePhotoViewModel:NSObject, ObservableObject {
    private let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)!
    private let output = AVCapturePhotoOutput()
    
    var session = AVCaptureSession()
    
    weak var coordinator:AddPostCoordinator?
    
    init(coordinator:AddPostCoordinator){
        self.coordinator = coordinator
        super.init()
        configureSession()
    }
    
    private func configureSession() {
        do{
            let input = try AVCaptureDeviceInput(device: device)
            session.beginConfiguration()
            if session.canAddInput(input){
                session.addInput(input)
            }
            if session.canAddOutput(output){
                session.addOutput(output)
            }
            session.commitConfiguration()
            
            DispatchQueue.global(qos: .userInitiated).async{[weak self] in
                self?.session.startRunning()
            }
        } catch {
            
        }
    }
    func takePhoto(){
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        output.capturePhoto(with: settings, delegate: self)
    }
}

extension TakePhotoViewModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation(),
              var image = UIImage(data: imageData) else { return }

        image = image.fixOrientation()

        saveImageToPhotoLibrary(image)
    }
    private func saveImageToPhotoLibrary(_ image: UIImage) {
            var placeholder: PHObjectPlaceholder?

            PHPhotoLibrary.shared().performChanges({
                let request = PHAssetChangeRequest.creationRequestForAsset(from: image)
                placeholder = request.placeholderForCreatedAsset
                }) { [weak self] success, error in
                    
                guard success,
                      let localIdentifier = placeholder?.localIdentifier else {
                    return
                }
                    
                let fetchResult = PHAsset.fetchAssets(
                    withLocalIdentifiers: [localIdentifier],
                    options: nil
                )
                guard let asset = fetchResult.firstObject else { return }

                DispatchQueue.main.async {
                    let media = Media.image(image: asset)
                    self?.coordinator?.openEditPost(with: media)
                }
            }
        }
}
