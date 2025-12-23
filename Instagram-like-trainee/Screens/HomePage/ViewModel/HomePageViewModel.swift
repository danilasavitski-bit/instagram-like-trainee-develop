//
//  MainPageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit
import Combine

final class HomePageViewModel: HomePage, ObservableObject {
    
    private var users = [User]()
    private var posts = [Post]()
    private var stories = [Story]()
    private var currentUser: User?
    private var coordinator: HomeCoordinator
    private var networkService:NetworkService
    private var cancellabeles: Set<AnyCancellable> = []
    @Published var dataUpdated: Bool = false
    var dataUpdatedPublisher: Published<Bool>.Publisher { $dataUpdated }
    
    init(coordinator: HomeCoordinator, networkService: NetworkService) {
        self.coordinator = coordinator
        self.networkService = networkService
        linkData()
    }
    private func linkData() {
        Publishers.CombineLatest4(
                networkService.$users,
                networkService.$posts,
                networkService.$stories,
                networkService.$currentUser
            )
            .filter { users, posts, stories, currentUser in
                !users.isEmpty &&
                !posts.isEmpty &&
                !stories.isEmpty &&
                currentUser != nil
            }
            .sink { users, posts, stories, currentUser in
                self.users = users
                self.posts = posts
                self.stories = stories
                self.currentUser = currentUser
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
    
    func getStoriesCount() -> Int {
        return stories.count
    }
    
    func getUsersWithStoriesId() -> [Int] {
        return getUsersWithStories().map { $0.id }
       
    }
    
    func getUserData(id: Int) -> HomeScreenUserData? {
        return getUserWithId(id)?.getHomeScreenUser()
    }
    
    func getUsersWithStoriesCount() -> Int {
        print("users with stories count - ", users.filter({ !$0.stories.isEmpty }).count )
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
        (coordinator.openDirect ?? {})()
    }
    
    func openStories(at index: Int) {
        
        coordinator.openStory?(storiesBundleIndex: index)
    }
    
    func didPressProfile(_ id: Int) {
        coordinator.openProfile(userId: id)
    }
    
    func checkIfUserStoriesSeen(data: HomeScreenUserData) -> Bool{
        let id = data.id
        let stories = stories.filter{ currentStory in
            return currentStory.userId == id
        }
        return stories.allSatisfy({$0.isSeen})
    }
    
    private func getUsersWithStories() -> [User] {
        return users.filter({ !$0.stories.isEmpty })
    }

    private func getUserWithId(_ id: Int) -> User? {
        return users.filter({ $0.id == id }).first
    }
    
}
