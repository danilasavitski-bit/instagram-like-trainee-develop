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
        let apiKey = RequestConstants.returnVideoKey()
        var videoURLs:[URL] = []
        let url = URL(string: "https://api.pexels.com/videos/popular?per_page=10")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
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
