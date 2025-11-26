//
//  MainPageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit

final class HomePageViewModel: NSObject, HomePage {
    
    private var users = [User]()
    private var posts = [Post]()
    private var stories = [Story]()
    private var currentUser: User?
    private var jsonService: JsonService
    private var coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator, jsonService: JsonService) {
        self.coordinator = coordinator
        self.jsonService = jsonService
        super.init()
        loadDataTask()
        
    }
   private func loadDataTask(){
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
        
        let usersData = getUsersData(from: usersJsonPath)
       validateUsersData(usersData: usersData)
        
        let postsData = getPostsData(from: postsJsonPath)
        validatePostsData(postsData: postsData)
        
        let storiesData = getStoriesData(from: storiesJsonPath)
       validateStoriesData(storiesData: storiesData)
    }
    
    private func getUsersData(from jsonPath: String?) -> Result<[User], ParseError> {
        let usersData = (
            jsonService.fetchFromJson(
                objectType: users,
                filePath: jsonPath ?? ""
            )
        )
        return usersData
    }
    private func getPostsData(from jsonPath: String?) -> Result<[Post], ParseError>{
        let postsData = jsonService.fetchFromJson(
                objectType: posts,
                filePath: jsonPath ?? ""
            )
        return postsData
    }
    
    private func getStoriesData(from jsonPath: String?) -> Result<[Story], ParseError>{
        let storiesData = jsonService.fetchFromJson(
                objectType: stories,
                filePath: jsonPath ?? ""
            )
        return storiesData
    }
    
    private func validateUsersData(usersData: Result<[User], ParseError>){
        switch usersData { //отступы
        case .success(let success):
            users.append(contentsOf: success)
            self.currentUser = self.users.popLast()
        case .failure(let failure):
            print(failure.description)
        }
    }
    
    private func validatePostsData(postsData: Result<[Post], ParseError>){
        switch postsData {
        case .success(let success):
            posts.append(contentsOf: success)
        case .failure(let failure):
            print(failure.description)
        }
    }
    
    private func validateStoriesData(storiesData: Result<[Story], ParseError>) {
        switch storiesData {
        case .success(let data):
            stories.append(contentsOf: data)
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

extension HomePageViewModel: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return getUsersWithStoriesCount() + 1
        case 1:
            return getPostsCount()
        default:
            return 0
        }
    }
    // swiftlint:disable all
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch indexPath.section {
                case 0:
                    if indexPath.row == 0 {
                        guard let cell: AddStoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath),
                              let image = getCurrentUserData()?.profileImage
                        else {
                            return AddStoryCollectionViewCell()
                        }
                        cell.configure(imageURL: image)
                        return cell
                    }
                    guard let cell: StoriesCollectionViewCell = collectionView.dequeueReusableCell(
                        for: indexPath),
                            let data = getUserData(id: getUsersWithStoriesId()[indexPath.row - 1 ]) else {
                        return StoriesCollectionViewCell()
                    }
                    cell.configure(imageName: data.profileImage, accountName: data.name)
                    return cell
                case 1:
                    guard let cell: PostCell = collectionView.dequeueReusableCell(
                        for: indexPath),
                            let post = getPostDataById(getPostsIdByTime()[indexPath.row])
                    else{
                        return PostCell()
                    }
                    guard let url = getUserData(id: post.userId)?.profileImage else { return cell }
                    cell.configure(
                        postImageURL: post.firstPhotoURL,
                        postHeaderImageURL: url,
                        postUserName: getUserData(
                            id: post.userId
                        )?.name ?? "N/A",
                        id: post.userId,
                        didPressProfile: didPressProfile
                    )
                    return cell
                default:
                    return UICollectionViewCell()
            }
        }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let header: HomeFeedHeaderView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            for: indexPath
        ), kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        header.didPressDirect = { [weak self] in self?.openDirectPage() }
        return header
    }
}
