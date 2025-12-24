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
   @Published var currentMedia: Media?
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
        photoService.requestPhotosAndVideosFromGallery { [weak self] assets in
            self?.photos = assets
            self?.currentMedia = .image(image:assets.firstObject!)
        }
    }
    
    func exportVideo(asset: PHAsset, completion: @escaping (URL?) -> Void) {
        let options = PHVideoRequestOptions()
        options.deliveryMode = .highQualityFormat
        
        PHCachingImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, _ in
            guard let avURLAsset = avAsset as? AVURLAsset else {
                completion(nil)
                return
            }
            
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("\(UUID().uuidString).mp4")
            
            do {
                try FileManager.default.copyItem(at: avURLAsset.url, to: tempURL)
                completion(tempURL)
            } catch {
                print("Ошибка копирования видео: \(error)")
                completion(nil)
            }
        }
    }
    
    
}
