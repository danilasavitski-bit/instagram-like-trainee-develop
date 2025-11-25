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
    private var jsonService: JsonService
    private var coordinator: HomeCoordinator

    init(coordinator: HomeCoordinator, jsonService: JsonService) {
        self.coordinator = coordinator
        self.jsonService = jsonService
        DispatchQueue.global().async { [weak self] in
            self?.fetchData()
        }
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

    private func fetchData() {
        let storiesJsonPath = Bundle.main.path(forResource: "stories", ofType: "json")
        let postsJsonPath = Bundle.main.path(forResource: "posts", ofType: "json")
        let usersJsonPath = Bundle.main.path(forResource: "users", ofType: "json")

        let usersData = (
            jsonService.fetchFromJson(
                objectType: users,
                filePath: usersJsonPath ?? ""
            )
        )
        switch usersData {
        case .success(let success):
            users.append(contentsOf: success)
            self.currentUser = self.users.popLast()
        case .failure(let failure):
            print(failure.description)
        }

        let postsData = (
            jsonService.fetchFromJson(
                objectType: posts,
                filePath: postsJsonPath ?? ""
            )
        )
        switch postsData {
        case .success(let success):
            posts.append(contentsOf: success)
        case .failure(let failure):
            print(failure.description)
        }

        let storiesData = (
            jsonService.fetchFromJson(
                objectType: stories,
                filePath: storiesJsonPath ?? ""
            )
        )
        switch storiesData {
        case .success(let success):
            stories.append(contentsOf: success)
        case .failure(let failure):
            print(failure.description)
        }
    }

    private func getUsersWithStories() -> [User] {
        return users.filter({ !$0.stories.isEmpty })
    }

    private func getUserWithId(_ id: Int) -> User? {
        return users.filter({ $0.id == id }).first
    }
}
