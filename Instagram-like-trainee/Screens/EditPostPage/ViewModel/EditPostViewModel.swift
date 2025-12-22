//
//  EditPostViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 12.12.25.
//
import UIKit
import Photos
import SwiftUI

class EditPostViewModel:ObservableObject {
    let networkService: NetworkService
    var originalImage: UIImage?
    let media: Media
    var videoURL: URL?
    @Published var image: UIImage = .init()
    var localIdentifier: String?
    weak var coordinator: AddPostCoordinator?
    
    init(media: Media, networkService: NetworkService,coordinator: AddPostCoordinator){
        self.media = media
        self.networkService = networkService
        self.coordinator = coordinator
        populateWithData(from: media)
    }
    func populateWithData(from media: Media) {
        switch media {
        case .image(image: let image):
            let imageManager = PHCachingImageManager()
            let options = PHImageRequestOptions()
            imageManager.requestImage(for: image, targetSize: .zero, contentMode: .aspectFill, options: options) { image, _ in
                self.image = image!
                self.originalImage = image!
            }
            
        case .video(url: let url):
            self.videoURL = url
        }
    }
    
    func postStory() {
        switch media {
        case .image:
            let correctedImage = image.fixOrientation()
            
            let tempURL = FileManager.default.temporaryDirectory
                .appendingPathComponent("\(UUID().uuidString).jpg")
            
            guard let data = correctedImage.jpegData(compressionQuality: 0.9) else {
                print("Не удалось создать JPEG из UIImage")
                return
            }
            
            do {
                try data.write(to: tempURL, options: .atomic)
                print("Файл сохранён по URL: \(tempURL)")
                
                let newPost = Post(
                    userId: networkService.currentUser!.id,
                    content: [tempURL],
                    comments: [],
                    likes: 0,
                    id: Int.random(in: 1...1000),
                    dateAdded: Date()
                )
                
                Task {
                    await MainActor.run {
                        self.networkService.publishPost(post: newPost)
                        self.coordinator?.openRootScreen()
                    }
                }
            } catch {
                print("Ошибка записи tmp JPEG: \(error)")
            }
        case .video :
            let newPost = Post(
                userId: networkService.currentUser!.id,
                content: [videoURL!],
                comments: [],
                likes: 0,
                id: Int.random(in: 1...1000),
                dateAdded: Date()
            )
            self.networkService.publishPost(post: newPost)
            self.coordinator?.openRootScreen()
        }
        
    }
}
