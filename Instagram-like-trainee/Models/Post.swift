//
//  Post.swift
//  ModelsTest
//
//  Created by Mikhail Kalatsei on 11/04/2024.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId: Int
    let content: [URL]
    let comments: [Comment]
    let likes: Int
    let id: Int
    let dateAdded: Date
}

extension Post {
    func getHomeScreenPost() -> HomeScreenPostData {
        return HomeScreenPostData(firstPhotoURL: self.content.first!, userId: self.userId)
    }
}
