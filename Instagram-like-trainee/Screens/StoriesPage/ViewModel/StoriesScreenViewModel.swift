//
//  StoriesScreenViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 8.12.25.
//
import Foundation

class StoriesScreenViewModel: ObservableObject{
    
    @Published var storiesBundles: [StoriesBundle] = []
    @Published var currentBundleIndex: Int
    @Published var currentStoryIndex:Int = 0
    private var coordinator:HomeCoordinator
    private var networkService:NetworkService
    
    init(currentBundleIndex: Int, coordinator: HomeCoordinator,networkService: NetworkService){
        self.currentBundleIndex = currentBundleIndex
        self.coordinator = coordinator
        self.networkService = networkService
        let usersWithStories = getUsersWithStories()
        let stories = networkService.stories
        populateBundleData(usersWithStories: usersWithStories, stories: stories)
    }
    func populateBundleData(usersWithStories:[User], stories: [Story]) {
        var storiesBundles: [StoriesBundle] = []
        for user in usersWithStories {
            let stories = stories.filter{
                $0.userId == user.id
            }
            storiesBundles.append(StoriesBundle(user: user, stories: stories))
        }
        self.storiesBundles = storiesBundles
    }
    
    func closeStories(){
        coordinator.closePage()
    }
    
    func markStoryAsSeen(story: Story, bundleIndex: Int){
        networkService.markStoryAsSeen(story: story)
        let index = storiesBundles[bundleIndex].stories.firstIndex(of: story)!
        storiesBundles[bundleIndex].stories[index].isSeen = true
    }
    
    private func getUsersWithStories() -> [User] {
        let usersWithStories = networkService.users.filter({ !$0.stories.isEmpty })
        return usersWithStories
    }
}

