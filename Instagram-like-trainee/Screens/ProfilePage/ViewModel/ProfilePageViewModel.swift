//
//  ProfilePageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 24/04/2024.
//

import SwiftUI

class ProfileViewModel: ObservableObject {
    weak var coordinator: HomePageCoordinator?
    var jsonService: JsonService
    @Published var data: ProfileData?
    var profileId: Int
    var users = [User]()
    var posts = [Post]()
    var stories = [Story]()

    func closeProfile() {
        self.coordinator?.closeProfile()
    }

    init(coordinator: HomePageCoordinator? = nil, id: Int, jsonService: JsonService) {
        self.coordinator = coordinator
        self.profileId = id
        self.jsonService = jsonService
        DispatchQueue.global().asyncAfter(deadline: .now()) { [weak self] in // зачем тут asyncAfter
            self?.fetchData()
            DispatchQueue.main.async {
                self?.populateWithUserData()
            }
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
        guard let user = users.filter({ user in
            user.id == id
        }).first else {
            return nil
        }
        return user
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
        case .success(let success): // нейминг переменной, то что успешно оно понятно - а туда записывается дата
            users.append(contentsOf: success)
        case .failure(let failure):
            print(failure.description)
        }

        let postsData = (
            jsonService.fetchFromJson(
                objectType: posts,
                filePath: postsJsonPath ?? ""
            )
        )
        // добавим пробельчик
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
        // и тут тоже
        switch storiesData {
        case .success(let success): // опять нейминг
            stories.append(contentsOf: success)
        case .failure(let failure):
            print(failure.description)
        }
    }
}
