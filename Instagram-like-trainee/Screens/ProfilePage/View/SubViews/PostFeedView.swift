//
//  PostFeedView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI

struct PostFeedView: View {
    var posts: [Post]

    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 120)),
        GridItem(.adaptive(minimum: 120)),
        GridItem(.adaptive(minimum: 120))
    ]

    init(posts: [Post]) {
        self.posts = posts
    }

    var body: some View {
        LazyVGrid(columns: adaptiveColumn,
                  spacing: 3,
                  content: {
            ForEach(posts) { post in
                if let content = post.content.first {
                    PostView(imageUrl: content)
                }
            }
        })
        .padding(5)
    }
}
