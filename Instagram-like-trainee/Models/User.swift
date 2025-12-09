//
//  User.swift
//  ModelsTest
//
//  Created by Mikhail Kalatsei on 11/04/2024.
//

import Foundation

struct User: Codable, Hashable {
    let name: String
    var posts: [Int]
    let subscribersId: [Int]
    let subscriptionsId: [Int]
    let dialogsId: [Int]
    var stories: [String]
    let description: String
    let profileImage: URL
    let id: Int
}

extension User {
    func getHomeScreenUser() -> HomeScreenUserData {
        return HomeScreenUserData(name: self.name, profileImage: self.profileImage, description: self.description, id: self.id)
    }
    mutating func clearStories(){
        self.stories = []
    }
}
