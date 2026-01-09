//
//  NetworkService.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import Foundation
import Network

class NetworkService: ObservableObject {
    @Published private(set) var currentUser: User?
    @Published private(set) var users: [User] = []
    @Published private(set) var posts: [Post] = []
    @Published private(set) var stories: [Story] = []
    @Published private(set) var dialogs: [Dialog] = []
    
    private let videoService = VideoService()
    private let session: URLSession
    
    private var page = 1
    
    private lazy var jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    init(with configuration: URLSessionConfiguration = .default) {
        session = URLSession(configuration: configuration)
    }
    
    func markStoryAsSeen(story: Story){
        let index = stories.firstIndex{ currentStory in
            return story.id == currentStory.id
        }
        if let index = index {
            stories[index].isSeen = true
            let userId = story.userId
            replaceUserToEnd(userId: userId)
        }
    }
    
    func publishPost(post:Post){
        posts.append(post)
    }
   
    func fetchData() async throws {
        var postId = 0
        var usersToReturn:[User] = []
        var storiesToReturn:[Story] = []
        var postsToReturn:[Post] = []
        let usersData = await fetchUsersFromJson(objectType: users)
        let dialogsData = await fetchDialogsFromJson(objectType: dialogs)
        let fetchedUsers = validateUsersData(usersData: usersData)
        let fetchedDialogs = validateDialogsData(usersData: dialogsData)

        try await populateWithData(fetchedUsers: fetchedUsers,
                                   fetchedDialogs: fetchedDialogs,
                                   usersToReturn: &usersToReturn,
                                   storiesToReturn: &storiesToReturn,
                                   postsToReturn: &postsToReturn,
                                   postId: &postId,
                                   page: &page)
        
        stories.append(contentsOf: storiesToReturn)
        posts.append(contentsOf: postsToReturn)
        users.append(contentsOf:usersToReturn)
        dialogs.append(contentsOf: fetchedDialogs)
    }
    
    private func populateWithData(fetchedUsers: [User],
                                  fetchedDialogs: [Dialog],
                                  usersToReturn: inout [User],
                                  storiesToReturn: inout [Story],
                                  postsToReturn: inout [Post],
                                  postId: inout Int,
                                  page: inout Int) async throws {
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
                let images = try jsonDecoder.decode([ImageItem].self, from: data)
                var userToAppend = user
                userToAppend.clearStories()
                //MARK: - Posts
                populateWithPosts(images: images,
                                  user: user,
                                  userToAppend: &userToAppend,
                                  postsToReturn: &postsToReturn,
                                  postId: &postId)
                //MARK: - Stories
                let numberOfStories = Int.random(in: 0...images.count)
                guard numberOfStories != 0 else {
                    usersToReturn.append(userToAppend)
                    continue
                }
                await populateUserWithStories(numberOfStories: numberOfStories,
                                              images: images,
                                              user: user,
                                              userToAppend: &userToAppend,
                                              storiesToReturn: &storiesToReturn,
                                              usersToReturn: &usersToReturn)
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
    }
    
    private func populateWithPosts(images: [ImageItem],
                                   user: User,
                                   userToAppend: inout User,
                                   postsToReturn: inout [Post],
                                   postId: inout Int) {
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
    }
    
    private func populateUserWithStories(numberOfStories: Int,
                                         images: [ImageItem],
                                         user: User,
                                         userToAppend: inout User,
                                         storiesToReturn: inout [Story],
                                         usersToReturn: inout [User]) async {
        for i in 1...numberOfStories {
            let id = UUID().uuidString
            if i%2 == 0 {
                addPhotoStory(to: user, withId: id,
                              usingImages: images,
                              atIndex: i,
                              userToAppend: &userToAppend,
                              storiesToReturn: &storiesToReturn)
            } else {
            await addVideoStory(to: user,
                                withId: id,
                                usingImages: images,
                                atIndex: i,
                                userToAppend: &userToAppend,
                                storiesToReturn: &storiesToReturn)
            }
        }
        usersToReturn.append(userToAppend)
    }
    
    private func addPhotoStory(to user: User,
                               withId id: String,
                               usingImages images: [ImageItem],
                               atIndex i: Int,
                               userToAppend: inout User,
                               storiesToReturn: inout [Story]){
        let story = Story(userId: user.id,
                          content: URL(string:images[i-1].urls.regular)!,
                          id: id,
                          dateAdded: Date())
        userToAppend.stories.append(id)
        storiesToReturn.append(story)
    }
    
    private func addVideoStory(to user: User,
                               withId id: String,
                               usingImages images: [ImageItem],
                               atIndex i: Int,
                               userToAppend: inout User,
                               storiesToReturn: inout [Story]) async {
        let videoURL = await videoService.requestVideoURLs()
        let randomNum = Int.random(in: 0...9)
        let story = Story(userId: user.id,
                          content: videoURL[randomNum],
                          id: id,
                          dateAdded: Date())
        userToAppend.stories.append(id)
        storiesToReturn.append(story)
    }
    
    private func fetchUsersFromJson<users: Codable>(objectType: users) async -> Result<[User], ParseError>  {
        await NetworkMonitor.shared.waitUntilConnected()
        let usersJsonPath = Bundle.main.path(forResource: "users", ofType: "json")
        if let data = FileManager().contents(atPath: usersJsonPath ?? "") {
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try jsonDecoder.decode([User].self, from: data)
                return .success(result)
            } catch {
                return .failure(ParseError.jsonError)
            }
        } else {
            return .failure(ParseError.fileError)
        }
    }
    
    private func fetchDialogsFromJson<users: Codable>(objectType: users) async -> Result<[Dialog], ParseError>  {
        await NetworkMonitor.shared.waitUntilConnected()
        let usersJsonPath = Bundle.main.path(forResource: "dialogs", ofType: "json")
        if let data = FileManager().contents(atPath: usersJsonPath ?? "") {
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let result = try jsonDecoder.decode([Dialog].self, from: data)
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
