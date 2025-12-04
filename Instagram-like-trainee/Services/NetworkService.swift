//
//  NetworkService.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import Foundation

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

class NetworkService {
    private(set) var currentUser: User?
    private(set) var users: [User] = []
    private(set) var posts: [Post] = []
    private(set) var stories: [Story] = []
    private var page = 0
    private let session: URLSession
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    init(with configuration: URLSessionConfiguration = .default) {
        session = URLSession(configuration: configuration)
    }
    // swiftlint: disable line_length
    func fetchData() async throws  {
        var postId = 0
        let usersData = fetchFromJson(objectType: users)
        let fetchedUsers = validateUsersData(usersData: usersData)
        var usersToReturn:[User] = []
        var postsToReturn:[Post] = []
        for user in fetchedUsers {
            let perPage = Int.random(in: 1...5)
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
                var userToAppend = user
                
                for image in images {
                    let post = Post(userId: user.id, content: [URL(string:image.urls.regular)!], comments: [], likes: Int.random(in: 0...300), id: postId, dateAdded: Date())
                    let numberOfStories = Int.random(in: 0...images.count)
                    for _ in 0...numberOfStories {
                        let story = Story(userId: user.id, content: URL(string:image.urls.regular)!, id: postId, dateAdded: Date())
                        stories.append(story)
                    }
                    userToAppend.posts.append(postId)
                    postsToReturn.append(post)
                    postId += 1
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
        }
        users.append(contentsOf:usersToReturn)
    }
    func fetchFromJson<users: Codable>(objectType: users) -> Result<[User], ParseError> {
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
    private func validateUsersData(usersData: Result<[User], ParseError>) -> [User]{
        switch usersData { //отступы
        case .success(let success):
//            self.currentUser = self.users.popLast()
            return success
        case .failure(let failure):
            print(failure.description)
            return []
        }
    }
}


struct ImageItem: Codable, Hashable {
    let urls: Urls
    enum CodingKeys: String, CodingKey {
        case urls
    }
}
// MARK: - Urls
struct Urls: Codable, Hashable {
    let regular: String
    enum CodingKeys: String, CodingKey {
        case regular
    }
}
