//
//  PostView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI

struct PostView: View {
    private var imageUrl: URL

    init(imageUrl: URL) {
        self.imageUrl = imageUrl
    }

    var body: some View {
        AsyncImage(url: imageUrl) { image in
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
