//
//  PostView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI
import AVKit

struct PostView: View {
    private var mediaURL: URL

    init(imageUrl: URL) {
        self.mediaURL = imageUrl
    }

    var body: some View {
        if isVideo(url: mediaURL) {
            let player = AVPlayer(url: mediaURL)
            VideoPlayer(player: player)
                .frame(width: 127, height: 127)
                .scaledToFill()
                .clipped()
            
        } else{
            AsyncImage(url: mediaURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 127, height: 127)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
        }
        
    }
    private func isVideo(url: URL) -> Bool {
        guard url.isFileURL else { return false }

        let videoExtensions: Set<String> = [
            "mp4", "mov", "m4v", "avi", "mkv", "webm"
        ]

        return videoExtensions.contains(url.pathExtension.lowercased())
    }
}
