//
//  ProfilePageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 24/04/2024.
//

import SwiftUI
protocol ProfilePageViewModelProtocol: ObservableObject {
    var data: ProfileData? { get set }
    var coordinator:HomeCoordinator?{ get set }
    var networkService: NetworkService { get set }
    var users: [User] { get set }
    var posts: [Post] { get set }
    var stories: [Story] { get set }
    func closeProfile()
}
class ProfileViewModel: ProfilePageViewModelProtocol {
    weak var coordinator: HomeCoordinator?
    var networkService: NetworkService
    @Published var data: ProfileData?
    var profileId: Int
    var users = [User]()
    var posts = [Post]()
    var stories = [Story]()

    func closeProfile() {
            coordinator?.closeProfile()
    }

    init(coordinator: HomeCoordinator? = nil, id: Int, networkService: NetworkService) {
        self.coordinator = coordinator
        self.profileId = id
        self.networkService = networkService
//        self.fillScreenWithUserDataTask()
        Task{
            users = networkService.users
            posts = networkService.posts
            stories = networkService.stories
            populateWithUserData()
        }
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

    private func getUserWithId(_ id: Int) -> User? {
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
    
//    private func getPostsData(from jsonPath: String?) -> Result<[Post], ParseError>{
//        let postsData = jsonService.fetchFromJson(
//                objectType: posts,
//                filePath: jsonPath ?? ""
//            )
//        return postsData
//    }
    
//    private func getStoriesData(from jsonPath: String?) -> Result<[Story], ParseError>{
//        let storiesData = jsonService.fetchFromJson(
//                objectType: stories,
//                filePath: jsonPath ?? ""
//            )
//        return storiesData
//    }
    
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
