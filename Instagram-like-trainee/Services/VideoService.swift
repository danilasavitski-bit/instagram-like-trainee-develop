//
//  VideoService.swift
//  Instagram-like-trainee
//
//  Created by  on 24.12.25.
//
import Foundation

class VideoService {
    private let session: URLSession
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    init(with configuration: URLSessionConfiguration = .default) {
        session = URLSession(configuration: configuration)
    }
    
    func requestVideoURLs() async  -> [URL]{
        var videoURLs:[URL] = []
        let url = URL(string: "https://api.pexels.com/videos/popular?per_page=10")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("xRGGBDx8pair_ca7327f9ef06481aaa66cc37a05f95e03A2rlMV3eRwBs4rQ4fNNf88XFjq8pw1UwjOI5puw9vfoP2U8", forHTTPHeaderField: "Authorization")
        do{
            let (data, _) = try await session.data(for: request)
            let responseData = try jsonDecoder.decode(Videos.self, from: data)
            for video in responseData.videos{
                videoURLs.append(URL(string:video.videoFiles[1].link)!)
            }
            
        } catch {}
        
        return videoURLs
    }
}
