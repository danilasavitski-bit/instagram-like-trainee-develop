//
//  JsonServiceMock.swift
//  Instagram-like-trainee
//
//  Created by  on 26.11.25.
//
import Foundation
@testable import Instagram_like_trainee
final class JsonServiceMock: JsonService { 
    var usersToReturn: [User] = [
        User(name: "User1", posts: [], subscribersId: [], subscriptionsId: [], dialogsId: [], stories: [1], description: "", profileImage: URL(string: "https://test.com")!, id: 1),
                    User(name: "User2", posts: [2], subscribersId: [], subscriptionsId: [], dialogsId: [], stories: [1,1], description: "", profileImage: URL(string: "https://test.com")!, id: 2),
                    User(name: "User3", posts: [], subscribersId: [], subscriptionsId: [], dialogsId: [], stories: [134134], description: "", profileImage: URL(string: "https://test.com")!, id: 3)
                
    ]
    var postsToReturn: [Post] = [
        Post(userId: 0, content: [URL(string:"https://test.com")!], comments: [Comment(text: "ll", likes: 15, userId: 3)], likes: 1, id: 2, dateAdded: Date())
    ]
    var storiesToReturn: [Story] = [
        Story(userId: 2, content: URL(string:"https://test.com")!, id: 2, dateAdded: Date())
    ]
        
        override func fetchFromJson<T>(objectType: T, filePath: String) -> Result<T, ParseError> where T : Decodable, T : Encodable {
            
            if let result = usersToReturn as? T {
                return .success(result)
            }
            if let result = postsToReturn as? T {
                return .success(result)
            }
            if let result = storiesToReturn as? T {
                return .success(result)
            }
            return .failure(.jsonError)
        }
}
