//
//  StoriesScreenViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 8.12.25.
//
import SwiftUI

class StoriesScreenViewModel: ObservableObject{
    
    @Published var storiesBundles: [StoriesBundle] = []
    @Published var currentBundleIndex: Int
    @Published var currentStoryIndex:Int = 0
    @Published var timer: Timer.TimerPublisher?
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
    
    func updateStory(forward: Bool = true, storyBundle: StoriesBundle, timerProgress: CGFloat, stopTimer: ()->Void){
        let index = min(Int(timerProgress),storyBundle.stories.count - 1)
        let story = storyBundle.stories[index]
        if !forward {
            if let first = storyBundle.stories.first, first.id == story.id {
                if storyBundle == storiesBundles.first {
                    return
                } else {
                    let bundleIndex = storiesBundles.firstIndex{ currentBundle in
                        return storyBundle.id == currentBundle.id
                    } ?? 0
                    withAnimation {
                       currentBundleIndex = bundleIndex - 1
                    }
                }
            }
        } else {
            if let last = storyBundle.stories.last, last.id == story.id {
                if let lastBundle = storiesBundles.last,lastBundle.id == storyBundle.id{
                    stopTimer()
                    closeStories()
                } else {
                    let bundleIndex = currentBundleIndex
                    if bundleIndex < storiesBundles.count - 1{
                        withAnimation {
                            currentBundleIndex = bundleIndex + 1
                        }
                    }
                }
            }
        }
    }
    
    private func getUsersWithStories() -> [User] {
        let usersWithStories = networkService.users.filter({ !$0.stories.isEmpty })
        return usersWithStories
    }
}

