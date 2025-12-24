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
    private var cache: NSCache<NSString,NSData> = .init()
    
    func requestPhotosAndVideosFromGallery(
        completion: @escaping (PHFetchResult<PHAsset>) -> Void
    ) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        fetchOptions.predicate = NSPredicate(
            format: "mediaType == %d OR mediaType == %d",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaType.video.rawValue
        )
        
        let assets = PHAsset.fetchAssets(with: fetchOptions)
        print(assets.count)
        
        completion(assets)
    }
    
    func fetchPhotosFromUrl(url: URL, completion: @escaping (Data) -> Void) async throws {
        guard let data = cache.object(forKey: url.absoluteString as NSString) else {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            let (data, _) = try await URLSession.shared.data(for: urlRequest)
            cache.setObject(data as NSData, forKey: url.absoluteString as NSString)
            Task {
                await MainActor.run {
                    completion(data)
                }
            }
            return
        }
        guard let data = data as? Data else { return }
        Task {
            await MainActor.run {
                completion(data as Data)
            }
        }
    }
}
