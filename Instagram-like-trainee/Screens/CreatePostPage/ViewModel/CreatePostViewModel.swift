//
//  CreatePostView.swift
//  Instagram-like-trainee
//
//  Created by  on 11.12.25.
//

import UIKit
import AVFoundation
import Photos

class CreatePostViewModel: ObservableObject {
   @Published var currentPhoto: PHAsset?
   @Published var photos: PHFetchResult<PHAsset> = .init()
    var photoService = PhotoLibraryService()
    weak var coordinator: AddPostCoordinator?
    
    init(coordinator:AddPostCoordinator){
        self.coordinator = coordinator
        requestPhotosPermission()
    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("Доступ к камере разрешен.")
            } else {
                print("Доступ к камере запрещен или недоступен.")
            }
        }
    }
    func requestPhotosPermission() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.requestPhotos()
            case .denied, .restricted:
                print("Доступ к галерее запрещен или недоступен.")
            default:
                break
            }
        }
    }
    
    func requestPhotos(){
        photoService.requestPhotosFromGallery { [weak self] assets in
            self?.photos = assets
            self?.currentPhoto = assets.firstObject
        }
    }
    
    
}
