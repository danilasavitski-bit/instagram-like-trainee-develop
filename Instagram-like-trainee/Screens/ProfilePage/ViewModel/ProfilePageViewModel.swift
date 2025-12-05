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
}
