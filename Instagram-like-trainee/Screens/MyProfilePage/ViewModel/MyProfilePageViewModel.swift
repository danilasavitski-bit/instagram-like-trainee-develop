//
//  ProfilePageViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 2.12.25.
//

import SwiftUI
import Combine

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
    @ObservedObject var networkService: NetworkService
    @Published var data: ProfileData?
    var profileId: Int
    var users = [User]()
    var posts = [Post]()
    var stories = [Story]()
    var cancellabeles: Set<AnyCancellable> = []

    init(coordinator: MyProfileCoordinatorProtocol? = nil, networkService: NetworkService, id: Int) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.profileId = id
        linkData()
    }
    private func linkData() {
        Publishers.CombineLatest3(
            networkService.$users,
            networkService.$posts,
            networkService.$stories
        )
        .sink { users, posts, stories in
            self.users = users
            self.posts = posts
            self.stories = stories
            self.populateWithUserData()
        }
        .store(in: &cancellabeles)
    }
    private func populateWithUserData() {
        guard !users.isEmpty else { return }
        guard let user = getUserWithId(profileId) else { return }

        let filteredPosts = posts.filter { $0.userId == profileId }
        self.data = ProfileData(
            posts: filteredPosts,
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
}
