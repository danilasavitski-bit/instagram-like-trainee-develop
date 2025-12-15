//
//  NetworkService.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import Foundation
import Network

struct RequestConstants {
    static private let resourceName = "Secrets"
    static private let extensionPlist = "plist"
    static private let keyValue = "clientId"
    static func returnClientId() -> String {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: extensionPlist) else { print("File not found"); return "" }
        guard let data = try? Data(contentsOf: url) else { print("Data not found"); return "" }
        let decoder = PropertyListDecoder()
        guard let clientId = try? decoder.decode([String: String].self, from: data)[keyValue] else { print("ClientId not found"); return "" }
        return clientId
    }
}

class NetworkService: ObservableObject {
    @Published private(set) var currentUser: User?
    @Published private(set) var users: [User] = []
    @Published private(set) var posts: [Post] = []
    @Published private(set) var stories: [Story] = []
    @Published private(set) var dialogs: [Dialog] = []
    
    private var page = 1
    private let session: URLSession
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    init(with configuration: URLSessionConfiguration = .default) {
        session = URLSession(configuration: configuration)
    }
    // swiftlint: disable line_length
    func fetchData() async throws {
        var postId = 0
        let usersData = await fetchUsersFromJson(objectType: users)
        let dialogsData = await fetchDialogsFromJson(objectType: dialogs)
        let fetchedUsers = validateUsersData(usersData: usersData)
        let fetchedDialogs = validateDialogsData(usersData: dialogsData)
        var usersToReturn:[User] = []
        var storiesToReturn:[Story] = []
        var postsToReturn:[Post] = []
        for user in fetchedUsers {
            let perPage = Int.random(in: 1...5)
            
            print("need \(perPage) images")
            let clientId = RequestConstants.returnClientId()
            guard let url = URL(string: "https://api.unsplash.com/photos?page=\(page)&per_page=\(perPage)&client_id=\(clientId)") else { throw URLError(.badURL) }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "GET"
            let (data, response) = try await session.data(for: urlRequest)
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode {
            case 200:
                print("Ok!")
                let images = try jsonDecoder.decode([ImageItem].self, from: data)
                print(images.count, "number of decoded images")
                var userToAppend = user
                userToAppend.clearStories()
                for image in images {
                    let post = Post(userId: user.id,
                                    content: [URL(string:image.urls.regular)!],
                                    comments: [],
                                    likes: Int.random(in: 0...300),
                                    id: postId,
                                    dateAdded: Date())
                    userToAppend.posts.append(postId)
                    postsToReturn.append(post)
                    postId += 1
                }
                let numberOfStories = Int.random(in: 0...images.count)
                guard numberOfStories != 0 else {
                    usersToReturn.append(userToAppend)
                    continue
                }
                for i in 1...numberOfStories {
                    let id = UUID().uuidString
                    let story = Story(userId: user.id, content: URL(string:images[i-1].urls.regular)!, id: id, dateAdded: Date())
                    userToAppend.stories.append(id)
                    storiesToReturn.append(story)
                }
                usersToReturn.append(userToAppend)
            case 301, 302, 304:
                print("redirection")
                throw URLError(.httpTooManyRedirects)
            case 400, 401, 403, 404:
                print("Bad Request")
                throw URLError(.badURL)
            case 500, 503, 504:
                print("Server Error")
                throw URLError(.badServerResponse)
            default:
                print("default case")
                throw URLError(.unknown)
            }
            page += 1
        }
        print(usersToReturn.count)
        stories.append(contentsOf: storiesToReturn)
        posts.append(contentsOf: postsToReturn)
        users.append(contentsOf:usersToReturn)
        dialogs.append(contentsOf: fetchedDialogs)
    }
    
    private func fetchUsersFromJson<users: Codable>(objectType: users) async -> Result<[User], ParseError>  {
        await waitUntilConnected()
        let usersJsonPath = Bundle.main.path(forResource: "users", ofType: "json")
        if let data = FileManager().contents(atPath: usersJsonPath ?? "") {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode([User].self, from: data)
                return .success(result)
            } catch {
                return .failure(ParseError.jsonError)
            }
        } else {
            return .failure(ParseError.fileError)
        }
    }
    
    private func fetchDialogsFromJson<users: Codable>(objectType: users) async -> Result<[Dialog], ParseError>  {
        await waitUntilConnected()
        let usersJsonPath = Bundle.main.path(forResource: "dialogs", ofType: "json")
        if let data = FileManager().contents(atPath: usersJsonPath ?? "") {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try decoder.decode([Dialog].self, from: data)
                return .success(result)
            } catch {
                return .failure(ParseError.jsonError)
            }
        } else {
            return .failure(ParseError.fileError)
        }
    }
    
    private func validateDialogsData(usersData: Result<[Dialog], ParseError>) -> [Dialog]{
        switch usersData {
        case .success(let success):
            return success
        case .failure(let failure):
            print(failure.description)
            return []
        }
    }
    
    private func validateUsersData(usersData: Result<[User], ParseError>) -> [User]{
        switch usersData {
        case .success(let success):
            self.currentUser = success.last
            return success
        case .failure(let failure):
            print(failure.description)
            return []
        }
    }
    
    func waitUntilConnected() async {
        return await withCheckedContinuation { continuation in
            if NetworkMonitor.shared.isConnected {
                continuation.resume()
            } else {
                NetworkMonitor.shared.onConnect = {
                    continuation.resume()
                }
            }
        }
    }
    
    func markStoryAsSeen(story: Story){
        let index = stories.firstIndex{ currentStory in
            return story.id == currentStory.id
        }
        if let index = index {
            
            stories[index].isSeen = true
            
            let story = stories[index]
            let userId = story.userId
            replaceUserToEnd(userId: userId)
        }
    }
    
    func publishPost(post:Post){
        posts.append(post)
    }
    
    private func replaceUserToEnd(userId:Int){
        let userStories = stories.filter({$0.userId == userId})
        if userStories.allSatisfy({$0.isSeen == true}) {
            let userIndex = users.firstIndex{$0.id == userId}!
            var users = users
            let userElement = users.remove(at: userIndex)
            users.append(userElement)
            self.users = users
        }
    }
    

}
