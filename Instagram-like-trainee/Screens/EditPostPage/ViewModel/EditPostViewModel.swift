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
    @Published var image: UIImage
    let originalImage: UIImage
    var localIdentifier: String?
    weak var coordinator: AddPostCoordinator?
    
    init(image: UIImage, networkService: NetworkService,coordinator: AddPostCoordinator){
        self.image = image
        self.originalImage = image
        self.networkService = networkService
        self.coordinator = coordinator
    }
    
    func postStory() {
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
    }
}
