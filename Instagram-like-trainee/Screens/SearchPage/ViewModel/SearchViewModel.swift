//
//  SearchViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 1.12.25.
//

import UIKit
import Combine

protocol SearchViewModelProtocol{
    func getPostsCount() -> Int
    func getUserData(id: Int) -> HomeScreenUserData?
    func getPostsIdByTime() -> [Int]
    func getPostDataById(_ id: Int) -> HomeScreenPostData?
    func lookForUsers(name: String) -> [HomeScreenUserData]
    func didPressProfile(_ id: Int)
    var dataUpdatedPublisher: Published<Bool>.Publisher {get}
}

final class SearchViewModel: SearchViewModelProtocol {
    
    private var users = [User]()
    private var posts = [Post]()
    private var networkService: NetworkService
    private var coordinator: SearchCoordinatorProtocol
    private var cancellabeles: Set<AnyCancellable> = []
    @Published var dataUpdated: Bool = false
    var dataUpdatedPublisher: Published<Bool>.Publisher { $dataUpdated }
    
    init(coordinator: SearchCoordinatorProtocol, networkService: NetworkService) {
        self.coordinator = coordinator
        self.networkService = networkService
        linkData()
    }
    private func linkData() {
        Publishers.CombineLatest(
            networkService.$users,
            networkService.$posts
        )
        .sink { users, posts in
            self.users = users
            self.posts = posts
            self.dataUpdated = true
        }
        .store(in: &cancellabeles)
    }
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
    
    private func getUserWithId(_ id: Int) -> User? {
        return users.filter({ $0.id == id }).first
    }
}
