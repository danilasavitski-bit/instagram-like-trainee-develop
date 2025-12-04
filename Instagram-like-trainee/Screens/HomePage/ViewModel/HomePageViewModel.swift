//
//  MainPageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit

final class HomePageViewModel: HomePage {
    
    private var users = [User]()
    private var posts = [Post]()
    private var stories = [Story]()
    private var currentUser: User?
    private var coordinator: HomeCoordinator
    private var networkService:NetworkService
    
    init(coordinator: HomeCoordinator, networkService: NetworkService) {
        self.coordinator = coordinator
        self.networkService = networkService
//        loadDataTask()
        Task{
//            try await networkService.fetchData()
            users = networkService.users
            posts = networkService.posts
            stories = networkService.stories
            currentUser = networkService.currentUser
            print(users.count , "users")
            print(posts.count , "posts")
            print(stories.count , "stories")
        }
        
    }
//   private func loadDataTask(){
//       DispatchQueue.global().async { [weak self] in
//            self?.fetchData()
//        }
//    }
    func getUsersCount() -> Int {
        return users.count
    }
    
    func getPostsCount() -> Int {
        return posts.count
    }
    
    func getStoriesCount() -> Int {
        return stories.count
    }
    
    func getUsersWithStoriesId() -> [Int] {
        return getUsersWithStories().map { $0.id }.sorted(by: <)
    }
    
    func getUserData(id: Int) -> HomeScreenUserData? {
        return getUserWithId(id)?.getHomeScreenUser()
    }
    
    func getUsersWithStoriesCount() -> Int {
        return users.filter({ !$0.stories.isEmpty }).count
    }
    
    func getPostsIdByTime() -> [Int] {
        return posts.sorted(by: { $0.dateAdded > $1.dateAdded }).map { $0.id }
    }
    
    func getPostDataById(_ id: Int) -> HomeScreenPostData? {
        return posts.filter({ $0.id == id }).first?.getHomeScreenPost()
    }
    
    func getCurrentUserData() -> HomeScreenUserData? {
        return currentUser?.getHomeScreenUser()
    }
    
    func openDirectPage() {
        coordinator.didPressDirect()
    }
    
    func didPressProfile(_ id: Int) {
        coordinator.didPressProfile(userId: id)
    }
    
//    private func fetchData() {
//        let storiesJsonPath = Bundle.main.path(forResource: "stories", ofType: "json")
//        let postsJsonPath = Bundle.main.path(forResource: "posts", ofType: "json")
//        let usersJsonPath = Bundle.main.path(forResource: "users", ofType: "json")
//        
//        let usersData = getUsersData(from: usersJsonPath)
//       validateUsersData(usersData: usersData)
//        
//        let postsData = getPostsData(from: postsJsonPath)
//        validatePostsData(postsData: postsData)
//        
//        let storiesData = getStoriesData(from: storiesJsonPath)
//       validateStoriesData(storiesData: storiesData)
//    }
    
//    private func getUsersData(from jsonPath: String?) -> Result<[User], ParseError> {
//        let usersData = (
//            jsonService.fetchFromJson(
//                objectType: users,
//                filePath: jsonPath ?? ""
//            )
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
//    
//    private func getStoriesData(from jsonPath: String?) -> Result<[Story], ParseError>{
//        let storiesData = jsonService.fetchFromJson(
//                objectType: stories,
//                filePath: jsonPath ?? ""
//            )
//        return storiesData
//    }
    
//    private func validateUsersData(usersData: Result<[User], ParseError>){
//        switch usersData { //отступы
//        case .success(let success):
//            users.append(contentsOf: success)
//            self.currentUser = self.users.popLast()
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

    private func getUsersWithStories() -> [User] {
        return users.filter({ !$0.stories.isEmpty })
    }

    private func getUserWithId(_ id: Int) -> User? {
        return users.filter({ $0.id == id }).first
    }
}
