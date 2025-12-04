//
//  SearchViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 1.12.25.
//

import UIKit

protocol SearchViewModelProtocol{
    func getPostsCount() -> Int
    func getUserData(id: Int) -> HomeScreenUserData?
    func getPostsIdByTime() -> [Int]
    func getPostDataById(_ id: Int) -> HomeScreenPostData?
    func lookForUsers(name: String) -> [HomeScreenUserData]
    func didPressProfile(_ id: Int) 

}

final class SearchViewModel: SearchViewModelProtocol {
    
    private var users = [User]()
    private var posts = [Post]()
    private var networkService: NetworkService
    private var coordinator: SearchCoordinatorProtocol
    
    init(coordinator: SearchCoordinatorProtocol, networkService: NetworkService) {
        self.coordinator = coordinator
        self.networkService = networkService
//        loadDataTask()
        Task{
//            try await networkService.fetchData()
            users = networkService.users
            posts = networkService.posts
            print(users.count , "users")
            print(posts.count , "posts")
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
    
    func getUserData(id: Int) -> HomeScreenUserData? {
        return getUserWithId(id)?.getHomeScreenUser()
    }
    
    func getPostsIdByTime() -> [Int] {
        let sortedPosts = posts.sorted(by: { $0.dateAdded > $1.dateAdded }).map { $0.id }
        return sortedPosts
    }
    
    func getPostDataById(_ id: Int) -> HomeScreenPostData? {
        return posts.filter({ $0.id == id }).first?.getHomeScreenPost()
    }
    
    func didPressProfile(_ id: Int) {
        coordinator.didPressProfile(userId: id)
    }
    
    func lookForUsers(name: String) -> [HomeScreenUserData] {
        if name.isEmpty {
                    return []
                } else {
                   let filteredUsers = users.filter {
                        $0.name.lowercased().contains(name.lowercased())
                    }
                    return filteredUsers.map{$0.getHomeScreenUser()}
                }
    }
//    
//    private func fetchData() {
//        let postsJsonPath = Bundle.main.path(forResource: "posts", ofType: "json")
//        let usersJsonPath = Bundle.main.path(forResource: "users", ofType: "json")
//        
//        let usersData = getUsersData(from: usersJsonPath)
//       validateUsersData(usersData: usersData)
//        
//        let postsData = getPostsData(from: postsJsonPath)
//        validatePostsData(postsData: postsData)
//        
//    }
//    
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
//    private func validateUsersData(usersData: Result<[User], ParseError>){
//        switch usersData { //отступы
//        case .success(let success):
//            users.append(contentsOf: success)
//            self.users.removeLast()
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


    private func getUserWithId(_ id: Int) -> User? {
        return users.filter({ $0.id == id }).first
    }
}
