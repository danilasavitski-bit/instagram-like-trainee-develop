//
//  ProfilePageViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 2.12.25.
//

import SwiftUI
protocol MyProfilePageModel: ObservableObject {
    var data: ProfileData? { get set }
    var coordinator:MyProfileCoordinatorProtocol?{ get set }
    var networkService: NetworkService { get set }
    var users: [User] { get set }
    var posts: [Post] { get set }
    var stories: [Story] { get set }
}
class MyProfileViewModel: MyProfilePageModel {
    weak var coordinator: MyProfileCoordinatorProtocol?
    var networkService: NetworkService
    @Published var data: ProfileData?
    var profileId: Int
    var users = [User]()
    var posts = [Post]()
    var stories = [Story]()

    init(coordinator: MyProfileCoordinatorProtocol? = nil, networkService: NetworkService, id: Int) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.profileId = id
        Task{
//            try await networkService.fetchData()
            users = networkService.users
            posts = networkService.posts
            stories = networkService.stories
            print(users.count , "users")
            print(posts.count , "posts")
            print(stories.count , "stories")
            self.populateWithUserData()
        }
//        self.fillScreenWithUserDataTask()
        
    }
//    private func fillScreenWithUserDataTask() {
//        DispatchQueue.global().async { [weak self] in
//            self?.fetchData()
//            DispatchQueue.main.async {
//                self?.populateWithUserData()
//            }
//        }
//    }
    private func populateWithUserData() {
        guard let user = getUserWithId(profileId) else { return }
        let posts = posts.filter({$0.userId == self.profileId})
        self.data = ProfileData(
            posts: posts,
            profileImage: user.profileImage,
            description: user.description,
            profileName: user.name
        )
    }

    private func getUserWithId(_ id: Int?) -> User? {
        guard let user = users.filter({ $0.id == id
        }).first else {
            return nil
        }
        return user
    }

//    private func fetchData()  {
//        let storiesJsonPath = Bundle.main.path(forResource: "stories", ofType: "json")
//        let postsJsonPath = Bundle.main.path(forResource: "posts", ofType: "json")
//        let usersJsonPath = Bundle.main.path(forResource: "users", ofType: "json")
//
//        let usersData = getUsersData(from: usersJsonPath)
//        validateUsersData(usersData: usersData)
//
//        let postsData = getPostsData(from: postsJsonPath)
//        validatePostsData(postsData: postsData)
//
//        let storiesData = getStoriesData(from: storiesJsonPath)
//        validateStoriesData(storiesData: storiesData)
//       
//    }
    
//    private func getUsersData(from jsonPath: String?) ->  Result<[User], ParseError>{
//        let usersData = jsonService.fetchFromJson(
//            objectType: users,
//            filePath: jsonPath ?? ""
//        )
//        return usersData
//    }
//    
//    private func getPostsData(from jsonPath: String?) -> Result<[Post], ParseError>{
//        let postsData = jsonService.fetchFromJson(
//                objectType: posts,
//                filePath: jsonPath ?? ""
//            )
//        return postsData
//    }
//    
//    private func getStoriesData(from jsonPath: String?) -> Result<[Story], ParseError>{
//        let storiesData = jsonService.fetchFromJson(
//                objectType: stories,
//                filePath: jsonPath ?? ""
//            )
//        return storiesData
//    }
//    
//    private func validateUsersData(usersData: Result<[User], ParseError>){
//        switch usersData {
//        case .success(let data):
//            users.append(contentsOf: data)
//        case .failure(let failure):
//            print(failure.description)
//        }
//    }
//    
//    private func validatePostsData(postsData: Result<[Post], ParseError>){
//        switch postsData {
//        case .success(let success):
//            posts.append(contentsOf: success)
//        case .failure(let failure):
//            print(failure.description)
//        }
//    }
//    
//    private func validateStoriesData(storiesData: Result<[Story], ParseError>) {
//        switch storiesData {
//        case .success(let data):
//            stories.append(contentsOf: data)
//        case .failure(let failure):
//            print(failure.description)
//        }
//    }
}
