//
//  PhotoService.swift
//  Instagram-like-trainee
//
//  Created by  on 11.12.25.
//

import Photos

final class PhotoLibraryService {
    private let imageManager = PHCachingImageManager()
    private(set) var assets: PHFetchResult<PHAsset> = PHFetchResult<PHAsset>()
    
    func requestPhotos(completion: @escaping (PHFetchResult<PHAsset>) -> Void) {
        let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            assets = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(assets.count)
        
        completion(assets)
    }
}
