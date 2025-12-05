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
        let usersData = await fetchFromJson(objectType: users)
        let fetchedUsers = validateUsersData(usersData: usersData)
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
                    let story = Story(userId: user.id, content: URL(string:images[i-1].urls.regular)!, id: postId, dateAdded: Date())
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
    }
    private func fetchFromJson<users: Codable>(objectType: users) async -> Result<[User], ParseError>  {
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
    private func validateUsersData(usersData: Result<[User], ParseError>) -> [User]{
        switch usersData { //отступы
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

}
//let connected = NetworkMonitor.shared.isConnected

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

class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitorQueue")

    public private(set) var isConnected: Bool = false

    var onConnect: (() -> Void)?  // <--- добавили callback
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = (path.status == .satisfied)

            if self.isConnected {
                self.onConnect?()
                self.onConnect = nil
            }
        }
        monitor.start(queue: queue)
    }
}
