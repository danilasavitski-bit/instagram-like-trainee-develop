//
//  ViewController.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit
import Combine

protocol HomePage {
    func getUsersCount() -> Int
    func getPostsCount() -> Int
    func getStoriesCount() -> Int
    func getUsersWithStoriesCount() -> Int
    func getUsersWithStoriesId() -> [Int]
    func getUserData(id: Int) -> HomeScreenUserData?
    func getPostsIdByTime() -> [Int]
    func getPostDataById(_ id: Int) -> HomeScreenPostData?
    func getCurrentUserData() -> HomeScreenUserData?
    func didPressProfile(_ id: Int)
    func openDirectPage()
    func openStories(at index: Int)
    func checkIfUserStoriesSeen(data: HomeScreenUserData) -> Bool
    var dataUpdatedPublisher: Published<Bool>.Publisher { get }
    
}

final class HomePageViewController: UIViewController {
    private var viewModel: HomePage
    private var cancellabeles: Set<AnyCancellable> = []
    private var isLoading: Bool = true
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.accessibilityIdentifier = "homePageCollectionView"
        return collectionView
    }()

    init(viewModel: HomePage) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
        setupConstraints()
    }
    private func bindData() {
        viewModel.dataUpdatedPublisher
            .filter({ value in
                value == true
            })
            .sink{ [weak self] _ in
            Task{
                await MainActor.run {
                    self?.isLoading = false
                    self?.collectionView.reloadData()
                }
            }
        }.store(in: &cancellabeles)
    }
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerWithoutXib(
            cellClasses: PostCell.self,
            StoriesCollectionViewCell.self,
            AddStoryCollectionViewCell.self)
        collectionView.register(
            HomeFeedHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HomeFeedHeaderView.identifier)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.height)
        ])
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let supItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(70)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        return supItem
    }

    private func createLayout() -> UICollectionViewCompositionalLayout {
        let supplementaryViews = [createHeader()]

        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 0,
                    leading: 0,
                    bottom: 2,
                    trailing: 0
                )

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .estimated(80),
                        heightDimension: .estimated(100)),
                    subitems: [item])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = supplementaryViews
                return section
            case 1:
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 1,
                    leading: 1,
                    bottom: 1,
                    trailing: 1
                )

                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(1.4)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)

                return section
            default:
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)),
                    subitems: [])

                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                return section
            }
        }
        return layout
    }
}

// MARK: - Collection View Extension
extension HomePageViewController:
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
        if let cell = cell as? PostCell {
            cell.startPlayer()
        }
        
    }

    func collectionView(
        _ collectionView: UICollectionView,
        didEndDisplaying cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        if let cell = cell as? PostCell {
            cell.stopPlayer()
        }
    }

}
extension HomePageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            let amountOfStories = viewModel.getUsersWithStoriesCount()
            if amountOfStories == 0 {
                return 5
            }
            return viewModel.getUsersWithStoriesCount() + 1 // потому что первая ячейка - ячейка юзера
        case 1:
            let postCount = viewModel.getPostsCount()
            if postCount == 0 {
                return 2
            }
            return viewModel.getPostsCount()
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
                        guard let cell: AddStoryCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath) else {
                            return AddStoryCollectionViewCell()
                        }
                        guard let image = viewModel.getCurrentUserData()?.profileImage else {
                            print("nothing")
                            return cell
                        }
                        cell.configure(imageURL: image)
                        return cell
                    }
                    guard let cell: StoriesCollectionViewCell = collectionView.dequeueReusableCell(
                        for: indexPath) else {
                        return StoriesCollectionViewCell()
                    }
                    guard viewModel.getUsersWithStoriesId().count >= indexPath.row else {
                        return cell
                    }
                    guard let data = viewModel.getUserData(id: viewModel.getUsersWithStoriesId()[indexPath.row - 1 ]) else {
                        return cell
                    }
                    cell.didPressStory = viewModel.openStories
                    let isSeen = viewModel.checkIfUserStoriesSeen(data: data)
                    cell.configure(imageName: data.profileImage, accountName: data.name, index: indexPath.row, isSeen: isSeen )
                    return cell
                case 1:
                    guard let cell: PostCell = collectionView.dequeueReusableCell(
                        for: indexPath) else {
                        return PostCell()
                    }
                    guard viewModel.getPostsIdByTime().count > indexPath.row else {
                        return cell
                    }
                    guard let post = viewModel.getPostDataById(viewModel.getPostsIdByTime()[indexPath.row])
                        else{
                            return cell
                        }
                guard let url = viewModel.getUserData(id: post.userId)?.profileImage else { return cell }
                    cell.configure(
                        postImageURL: post.firstPhotoURL,
                        postHeaderImageURL: url,
                        postUserName: viewModel.getUserData(
                            id: post.userId
                        )?.name ?? "N/A",
                        id: post.userId,
                        didPressProfile: viewModel.didPressProfile
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
        header.didPressDirect = { [weak self] in self?.viewModel.openDirectPage() }
        return header
    }
}
// swiftlint:enable all
