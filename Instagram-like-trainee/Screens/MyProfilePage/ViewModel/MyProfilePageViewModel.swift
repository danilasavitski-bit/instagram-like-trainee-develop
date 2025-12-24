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
    var currentUser: User?
    var users = [User]()
    var posts = [Post]()
    var stories = [Story]()
    var cancellabeles: Set<AnyCancellable> = []

    init(coordinator: MyProfileCoordinatorProtocol? = nil, networkService: NetworkService) {
        self.coordinator = coordinator
        self.networkService = networkService
        linkData()
    }
    
    func isVideo(url: URL) -> Bool {
        guard url.isFileURL else { return false }

        let videoExtensions: Set<String> = [
            "mp4", "mov", "m4v", "avi", "mkv", "webm"
        ]

        return videoExtensions.contains(url.pathExtension.lowercased())
    }
    
    private func linkData() {
        Publishers.CombineLatest4(
            networkService.$users,
            networkService.$posts,
            networkService.$stories,
            networkService.$currentUser
        )
        .sink { users, posts, stories, currentUser in
            self.users = users
            self.posts = posts
            self.stories = stories
            self.currentUser = currentUser
            Task{
               await  MainActor.run{
                    self.populateWithUserData()
                }
            }
            
            
        }
        .store(in: &cancellabeles)
    }
    private func populateWithUserData() {
        guard !users.isEmpty else { return }
        guard let user = currentUser else { return }

        let filteredPosts = posts.filter { $0.userId == currentUser?.id }
        self.data = ProfileData(
            posts: filteredPosts,
            profileImage: user.profileImage,
            description: user.description,
            profileName: user.name
        )
    }
}
