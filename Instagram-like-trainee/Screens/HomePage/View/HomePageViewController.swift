//
//  ViewController.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit
protocol HomePage: UICollectionViewDataSource {
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
}

final class HomePageViewController: UIViewController {
    private var viewModel: HomePage

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(viewModel: HomePage) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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

    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = viewModel
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor), //зачем константа если все равно 0
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor), //зачем константа если все равно 0
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
extension HomePageViewController: // разделил бы протоколы
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {


}
// swiftlint:enable all
